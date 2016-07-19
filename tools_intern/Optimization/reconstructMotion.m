function [rec] = reconstructMotion(T,skel,mot,scheme,varargin)

core                = T.core;
rootcore            = T.rootcore;

numNaturalModes     = T.numNaturalModes;
numTechnicalModes   = T.numTechnicalModes;
numDim              = numTechnicalModes+numNaturalModes; 
dimAllModes         = [T.dimTechnicalModes T.dimNaturalModes];

setDefault                  = defaultSet();
setDefault.regardedJoints   = (1:31);
    
switch scheme
    case 'default'
        set                 = setDefault;  
        set.lowerBounds     = num2str(set.lowerBounds);
        set.upperBounds     = num2str(set.upperBounds);
    case 'wizzard'
        fprintf('\nThe wizzard will help you to initiate the optimization. <Enter> always sets default values!\n');
        
        set.optimVar    = input('Choose optimization scheme! (x (default) or y) ','s'); 
        set.lowerBounds = input('Choose lower bound for coefficients (x-representation)! (default: -1) ','s');
        set.upperBounds = input('Choose upper bound for coefficients (x-representation)! (default: +2) ','s');
        
        fprintf('Choose modes to optimize! (default: [%i',numTechnicalModes+1);
        for i=2:numNaturalModes
            fprintf(',%i',numTechnicalModes+i);
        end
        set.modesToOptimize = input(']) ');
        
        set.trajectories    = 'xxx';
        while      ~strcmpi(set.trajectories,'pos')...
                && ~strcmpi(set.trajectories,'vel')...
                && ~strcmpi(set.trajectories,'acc')...
                && ~strcmpi(set.trajectories,'exp')...
                && ~strcmpi(set.trajectories,'quat')...
                && ~isempty(set.trajectories)
            set.trajectories    = lower(input('Choose trajectories for optimization! quat,exp,pos,vel,acc(default) ','s'));
            if strcmpi(set.trajectories,'pos')
                setDefault.regardedJoints   = setDefault.regardedJoints(~cellfun(@isempty,mot.jointTrajectories));
            elseif strcmpi(set.trajectories,'vel')
                if isfield(mot,'jointVelocities');
                    setDefault.regardedJoints   = setDefault.regardedJoints(~cellfun(@isempty,mot.jointVelocities));
                else
                    setDefault.regardedJoints   = setDefault.regardedJoints(~cellfun(@isempty,mot.jointTrajectories));
                end
            elseif strcmpi(set.trajectories,'acc')||(isempty(set.trajectories))
                if isfield(mot,'jointAccelerations');
                    setDefault.regardedJoints   = setDefault.regardedJoints(~cellfun(@isempty,mot.jointAccelerations));
                else
                    setDefault.regardedJoints   = setDefault.regardedJoints(~cellfun(@isempty,mot.jointTrajectories));
                end
            elseif strcmpi(set.trajectories,'exp')||(isempty(set.trajectories))
                if isfield(mot,'rotationQuat');
                    setDefault.regardedJoints   = setDefault.regardedJoints(~cellfun(@isempty,mot.rotationQuat));
                else
                    setDefault.regardedJoints   = setDefault.regardedJoints(~cellfun(@isempty,mot.jointTrajectories));
                end
            elseif strcmpi(set.trajectories,'quat')||(isempty(set.trajectories))
                if isfield(mot,'rotationQuat');
                    setDefault.regardedJoints   = setDefault.regardedJoints(~cellfun(@isempty,mot.rotationQuat));
                else
                    setDefault.regardedJoints   = setDefault.regardedJoints(~cellfun(@isempty,mot.jointTrajectories));
                end
            end
        end
       
        fprintf('Choose joints for optimization! (default: [');
        if length(setDefault.regardedJoints)==31
            fprintf('1:31 ');
        else
            fprintf('%i ',setDefault.regardedJoints);
        end
        fprintf('\b');
        set.regardedJoints  = input(']) ');
        
        set.jointToDisplay  = input('Choose joint for display during optimization! (default: no display) ');
        set.startValue      = input('Choose start value (x-representation) for optimization! ');
        numOptimizer        = input('Choose number of used Optimizers! (default: 1)');
        if isempty(numOptimizer)
            numOptimizer=1;
        end
        for opt=1:numOptimizer
            set.optimizer{opt}= input('Choose optimizer! simann, lsqnonlin (default) ', 's');
        end
        
        
    case 'set' 
        set                 = varargin{1};
        set.lowerBounds     = num2str(set.lowerBounds);
        set.upperBounds     = num2str(set.upperBounds);
end

if isempty(set.modesToOptimize) % default
    set.modesToOptimize = numTechnicalModes+(1:numNaturalModes);
end

if isempty(set.optimVar) % default
    set.optimVar=setDefault.optimVar;
end

if isempty(set.lowerBounds) % default
    set.lowerBounds = setDefault.lowerBounds;
    lb              = set.lowerBounds...
                      *ones(1,sum(dimAllModes(set.modesToOptimize)));
elseif strcmp(set.lowerBounds,'[]')
    lb              = [];
else
    lb              = str2double(set.lowerBounds)...
                      *ones(1,sum(dimAllModes(set.modesToOptimize)));
end

if isempty(set.upperBounds) % default
    set.upperBounds = setDefault.upperBounds;
    ub              = set.upperBounds...
                      *ones(1,sum(dimAllModes(set.modesToOptimize)));
elseif strcmp(set.upperBounds,'[]')
    ub              = [];
else
    ub              = str2double(set.upperBounds)...
                      *ones(1,sum(dimAllModes(set.modesToOptimize)));
end

if set.optimVar=='y' 
    if isempty(lb) || isempty(ub)
        lb=[];
        ub=[];
    else
        [lb,ub]=transformBoundaries(lb,ub,T.factors,set.modesToOptimize);
    end
end

if isempty(set.regardedJoints) % default
    set.regardedJoints  = setDefault.regardedJoints;
end
if isempty(set.trajectories) % default
    set.trajectories    = setDefault.trajectories;
end

if isempty(set.optimizer) || isempty(set.optimizer{1}) %default
    set.optimizer{1}='lsqnonlin';
end

for i=1:length(T.form)
    if strcmpi(T.form{i},'joints')
        jointModeID=i;
        break;
    end
end
modesNotToOptimize      = setxor((1:numDim),set.modesToOptimize);
rootModesToOptimize     = set.modesToOptimize(set.modesToOptimize~=jointModeID);
rootModesToOptimize(rootModesToOptimize>jointModeID)=...
    rootModesToOptimize(rootModesToOptimize>jointModeID)-1;
rootModesNotToOptimize  = setxor((1:numDim-1),rootModesToOptimize);

% Set default start value for optimization
X0default   = cell(1,length(set.modesToOptimize));
Y0default   = cell(1,length(set.modesToOptimize));
x0default   = [];
y0default   = [];
dimsX       = [];
dimsY       = [];
counter     = 0;

for i=set.modesToOptimize
    counter             = counter+1;
    X0default{counter}  = ones(1,dimAllModes(i))/dimAllModes(i);
    Y0default{counter}  = X0default{counter}*T.factors{i};
    x0default           = [x0default X0default{counter}];
    y0default           = [y0default Y0default{counter}];
    dimsX               = [dimsX size(X0default{counter},2)];
    dimsY               = [dimsY size(Y0default{counter},2)];
end

if isempty(set.startValue)
    if set.optimVar=='x'
        set.startValue = x0default;
    elseif set.optimVar=='y'
        set.startValue = y0default;
    end
else
    if iscell(set.startValue)
        set.startValue=cellArrayToVector(set.startValue);
    end
    if set.optimVar=='y'
        set.startValue=vectorToCellArray(set.startValue,dimAllModes(set.modesToOptimize));
        counter=0;
        for i=set.modesToOptimize
            counter             = counter+1;
            set.startValue{counter} = set.startValue{counter}*T.factors{i};
        end
        set.startValue = cellArrayToVector(set.startValue);
    end
end

fprintf('\n');
disp(set);

for i=1:length(T.form)
    if strcmpi(T.form{i},'frames')
        frameModeID=i;
        break;
    end
end

rec.regardedJoints=set.regardedJoints;
dimsAfterOptim=dimAllModes;
dimsAfterOptim(set.modesToOptimize)=1;
doUnwarp=false;
if mot.nframes~=dimsAfterOptim(frameModeID);
    % DTW necessary!
    doUnwarp     = true;
    mot          = changeFrameRate(skel,mot,T.samplingRate);
    if ~(isempty(mot.rootTranslation))&&~(isempty(mot.rotationQuat))
        mot          = fitMotion(skel,mot);
    end
    rec.origMot  = mot;
    [xx,fitmot]  = extractMotion(T,T.DTW.refMotID);
    [D,w]        = pointCloudDTW(fitmot,mot,'pos',set.regardedJoints,1);
    mot          = warpMotion(w,skel,mot);
    rec.DTWref   = fitmot;
    rec.DTWpath  = w;
    rec.DTWmot   = mot;
end

switch lower(set.trajectories)
    case 'pos'
        optimStruct.originalTraj    = mot.jointTrajectories;
    case 'vel'
        if ~isfield(mot,'jointVelocities')
            mot         = addVelToMot(mot);
        end
        optimStruct.originalTraj    = mot.jointVelocities;
    case 'acc'
        if ~isfield(mot,'jointAccelerations');
            mot=addAccToMot(mot);
        end
        optimStruct.originalTraj = mot.jointAccelerations; 
    case 'exp'
        for j=1:mot.njoints
            if(~isempty(mot.rotationQuat{j}))
                mot.rotationExpMap{j}=quatlog(mot.rotationQuat{j});
            end
        end
        optimStruct.originalTraj = mot.rotationExpMap;
    case 'quat'
        for j=1:mot.njoints
            if(isempty(mot.rotationQuat{j}))
                mot.rotationQuat{j}(1  ,:)= ones(1,mot.nframes);
                mot.rotationQuat{j}(2:4,:)=zeros(3,mot.nframes);
            end
        end
        optimStruct.originalTraj = mot.rotationQuat;
end

% -------------------------------------------------------------------------
for i=modesNotToOptimize
    core        = modeNproduct(core,T.factors{i},i);
end
for i=rootModesNotToOptimize
    rootcore    = modeNproduct(rootcore,T.rootfactors{i},i);
end
%--------------------------------------------------------------------------

if ~isempty(set.jointToDisplay)
    optimStruct.axesBoundaries  = ...
        [min(optimStruct.originalTraj{set.jointToDisplay}(1,:)),...
        max(optimStruct.originalTraj{set.jointToDisplay}(1,:)),...
        min(optimStruct.originalTraj{set.jointToDisplay}(2,:)),...
        max(optimStruct.originalTraj{set.jointToDisplay}(2,:)),...
        min(optimStruct.originalTraj{set.jointToDisplay}(3,:)),...
        max(optimStruct.originalTraj{set.jointToDisplay}(3,:))];
end

optimStruct.optimVar            = set.optimVar;
optimStruct.jointToPlot         = set.jointToDisplay;
optimStruct.tensor              = T;
optimStruct.preparedCore        = core;
optimStruct.preparedRootCore    = rootcore;
optimStruct.skel                = skel;
optimStruct.consideredJoints    = set.regardedJoints;
optimStruct.trajRep             = set.trajectories;
optimStruct.origmot             = mot;
optimStruct.modesToOptimize     = set.modesToOptimize;
optimStruct.rootModesToOptimize = rootModesToOptimize;

optimStruct.currMotion          = set.currMotion;

% Set options for optimization --------------------------------------------
options = optimset( 'Display','iter',...
                    'MaxFunEvals',100000,...
                    'MaxIter',100,...
                    'TolFun',0.00001);%,...
%                      'PlotFcns', @optimplotx);
%                     'TolX',0.01);

for o=1:size(set.optimizer,2)
    switch set.optimizer{o}
        
        case 'lsqnonlin'
            if set.optimVar=='x'
                optimStruct.optimDims = dimsX;
                if o>1
                    set.startValue=Xs;
                end
                tic;
                [X,rec.RESNORM,rec.RESIDUAL] = lsqnonlin(@(x) objfun(x,optimStruct),set.startValue,lb,ub,options);
                toc
                X=vectorToCellArray(X,dimsX);
            elseif set.optimVar=='y'
                optimStruct.optimDims = dimsY;
                if o>1
                    set.startValue=Xs;
                end
                tic;
                [Y,rec.RESNORM,rec.RESIDUAL] = lsqnonlin(@(x) objfun(x,optimStruct),set.startValue,lb,ub,options);
                toc
                Y=vectorToCellArray(Y,dimsY);
                X=cell(size(Y));
                counter = 0;
                for i=set.modesToOptimize
                    counter = counter+1;
%                     X{counter}=Y{counter}/T.factors{i};
                    X{counter}=Y{counter}*pinv(T.factors{i});
                end
            end
        case 'simann'
            if set.optimVar=='x'
                optimStruct.optimDims = dimsX;
                if o>1
                    set.startValue=Xs;
                end
                tic;
                [X] = findCoefficientsSimulatedAnnealingX(set,optimStruct);
                toc;
                Xs=X;
                X=vectorToCellArray(X,dimsX);
            elseif set.optimVar=='y'
                optimStruct.optimDims = dimsY;
                if o>1
                    set.startValue=Xs;
                end
                tic;
                [Y] = findCoefficientsSimulatedAnnealingY(set,optimStruct);
                toc;
                Xs=Y;
                Y=vectorToCellArray(Y,dimsY);
                X=cell(size(Y));
                counter = 0;
                for i=set.modesToOptimize
                    counter = counter+1;
%                     X{counter}=Y{counter}/T.factors{i};
                    X{counter}=Y{counter}*pinv(T.factors{i});
                end
            end
        otherwise
            error('You selected an unknown optimizer!\n');
    end
end
% -------------------------------------------------------------------------
rec.X=X;
counter = 0;
for i=set.modesToOptimize
    counter = counter+1;
    core    = modeNproduct(core,X{counter}*T.factors{i},i);
end

counter = 0;
for i=rootModesToOptimize
    counter = counter+1;
    rootcore    = modeNproduct(rootcore,X{counter}/sum(X{counter})*T.rootfactors{i},i);
end

rec.skel            = skel;
rec.motRec          = createMotionFromCoreTensor_jt(core,rootcore,skel,true,true,T.DataRep);
if doUnwarp
    rec.motRecUnwarped  = warpMotion(fliplr(w),skel,rec.motRec);
    rec.distUnwarped    = compareMotionsCrossProduct(skel,rec.motRecUnwarped,rec.origMot);
    rec.distWarped      = compareMotionsCrossProduct(skel,rec.motRec,rec.DTWmot);
end

% rec.motRecNoSkate   = removeSkating(skel,rec.motRec);
