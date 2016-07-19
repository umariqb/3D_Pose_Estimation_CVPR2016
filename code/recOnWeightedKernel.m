function [er, optim, opts] = recOnWeightedKernel(varargin)
tic
%% options updates
close all;
if(nargin == 0)
    [opts, ~] = initializeOpts;
elseif(nargin == 1)
    [opts, ~] = initializeOpts(varargin{1});
elseif(nargin == 2)
    [opts, ~] = initializeOpts(varargin{1},varargin{2});
elseif(nargin == 3)
    [opts, ~] = initializeOpts(varargin{1},varargin{2},varargin{3});
elseif(nargin == 4)
    [opts, ~] = initializeOpts(varargin{1},varargin{2},varargin{3},varargin{4});
elseif(nargin == 5)
    [opts, ~] = initializeOpts(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5});
else
    disp('error: wrong number of input arguments');
end
%% Options to select
opts.round    = 1;
opts.database = 'CMU_amc_regFit';

opts.loadPath  = fullfile('../Data/');
opts.loadInPath  = fullfile('../Data/');
opts.saveResPath = fullfile('../Data/');
if ~exist(opts.saveResPath,'dir')
    mkdir(opts.saveResPath);
end
%% Loading input anf GT

[motIn,~, opts] = loadnPrepareQMot(opts);
load(fullfile([opts.loadPath 'motGT_' opts.subject '_' opts.actName ])); %gt
estP2D = cell2mat(motIn.jointTrajectories2DF);
[cm.fc, cm.cc, cm.alpha_c, cm.kc, cm.Rc_ext, cm.omc_ext, cm.Tc_ext] = readSpicaCalib(opts.pathCalFile);
%% Loading nn
%shape    = {'upper';'lower';'left';'right';'pose'};
try
    shape = motIn.bodyTypeOrder;
catch
    disp('Please load right input');
end
for h = 1:length(shape)
    loadPath              = opts.loadPath;
    idName                = [opts.subject '_' opts.actName  '_' num2str(opts.knn) '_' shape{h} '_obj.mat'];
    load([loadPath idName]);
    objAll{h,1}.obj       = obj;
    objAll{h,1}.knn       = opts.knn;
    objAll{h,1}.knnJoints = opts.allJoints;
    objAll{h,1}.bodyType  = shape{h};
    
    idNameCM              = [opts.subject '_' opts.actName  '_' num2str(opts.knn) '_' shape{h} '_camMtx.mat'];
    fileCM                = [loadPath idNameCM];
    load(fileCM);
    camMtxAll{h,1}        = camMtx;   
    loadPath          = opts.loadPath;    
    
    opts.cJno         = getShapeJointNum(shape{h},opts.inputDB);
    [opts.allJoints, opts.cJoints] = getJointsHE (opts.inputDB,opts.database,opts.cJno,shape{h});
    opts              = getJointsIdx(opts);
    jnts.cJidx{h,1}   = opts.cJidx;
    jnts.cJidx2{h,1}  = opts.cJidx2;
    jnts.cJidx3{h,1}  = opts.cJidx3;
end
%% reconstruction options

erJoints               = 14;
selknn                 = 256;
nknn                   = 64; % 64
optim.nknn             = nknn;

optim.nrOfSVPosePriorP = 18;    %18   % 25 %30                                 
optim.nrOfPrinComps    = 18;    %18   % 25 %30
optim.w_pose           = .35;        %20   .60
optim.w_control        = .55;        %10   .45
optim.w_pose2D         = .25;        %10     0
optim.w_limb           = .065;         %10  .05

fprintf('%3d ', optim.w_pose  );
fprintf('%3d ', optim.w_control);
fprintf('%3d ', optim.w_pose2D );
fprintf('%3d ', optim.w_limb  );
disp(' . . . done');

optim.expPPrior        = 0.5;
optim.expMPrior        = 0.5;
optim.expSmooth        = 0.5;
optim.expControl       = 0.5;
optim.jointWeights     = 1;
optim.jointWeights2D   = 1;
% optim.jointWeights     = ones(3*length(opts.allJoints),selknn);
% optim.jointWeights2D     = ones(2*length(opts.allJoints),selknn);

optLSQ      = optimset( 'Display','none',... %'iter',
    'MaxFunEvals',100000,...
    'MaxIter',1000,...
    'TolFun',0.001,...
    'TolX',0.001,...
    'LargeScale','on',...
    'Algorithm','levenberg-marquardt');
lb = [];
ub = [];
%--------------------------------------------------------------------------
lbb   = -0.5;
ubb   = 1.5;
startValueMtx = [0;0;0;0;0;0];
windowsize = 4;   % for 5 we have to select 4
optimOpts = optimset(...
    'Display','off',...           % 'Display','iter'
    'MaxIter',10000,...
    'MaxFunEvals',10000,...  %     'PlotFcns', @optimplotx, ...
    'Algorithm' , 'trust-region-reflective' , ...%'trust-region-reflective',... %'levenberg-marquardt' , ...
    'TolX',0.001);

%% Reconstruction
optim.limlenIdx = H_calLimbLengthIdx(opts.allJoints);

sknnObj     = obj;
obj.data    = [];
sknnObj.knn = nknn;
sknnObj.data = nan(nknn*3*motIn.njoints, motIn.nframes);
toc

tic
fprintf('Reconstruction: Frame no. ...     ');
for f = 1:motIn.nframes
    fprintf('%3d ', f);
    sObj = objAll{motIn.bodyType(f),1};
    sknn = sObj.obj.data(:,f);
    sknn = reshape(sknn,3*length(opts.allJoints),[]);    
    sknn = sknn(:,1:selknn);
    for j = 1:length(optim.limlenIdx)  
        optim.limlen(j,:) = sqrt(sum((sknn(optim.limlenIdx(j,1:3),:) - sknn(optim.limlenIdx(j,4:6),:)).^2));
        %optim.limlen(j,:) = sum(sqrt((sknn(optim.limlenIdx(j,1:3),:) - sknn(optim.limlenIdx(j,4:6),:)).^2));
    end    
    %====================================================================== weights regularization
    w            = motIn.knnWts(1:selknn,f)';
    ind          = find(w>1);
    w(ind)       = 0;
    w            = regulateWeights(w);
    [~, wtidx]   = sort(w,'descend');
    w            = w(wtidx(1:nknn));
    
    sw           = sum(w);
    optim.limlen = optim.limlen(:,wtidx(1:nknn));    
    sknn         = sknn(:,wtidx(1:nknn));
    
    sknnObj.data(:,f) = sknn(:);
    %======================================================================
    opts.bodyType = sObj.bodyType;
    opts.cJno = getShapeJointNum(opts.bodyType,opts.inputDB);
    [opts.allJoints, opts.cJoints] = getJointsHE (opts.inputDB,opts.database,opts.cJno,opts.bodyType);
    opts = getJointsIdx(opts);
    optim.estP2D = estP2D(:,f);
    optim.camMtx = cell2mat(camMtxAll{motIn.bodyType(f),1}(f,1));
    optim.cJidx2 = opts.cJidx2;
    optim.wtPose = w;
    
    %======================================================================
    % knn repeats according to the weights for weighted pca
    wlm = ceil(w*10);
    for k = 1:length(wlm)
        nn = repmat(sknn(:,k),1,wlm(k));
        nn2d = repmat(sknn(:,k),1,wlm(k));
        wt = repmat(w(k),1,wlm(k));
        if (k == 1)
            nnrep = nn;
            nnrep2d = nn2d;
            wrep = wt;
        else
            nnrep = [nnrep,nn];
            nnrep2d = [nnrep2d,nn2d];
            wrep = [wrep,wt];
        end
    end
    optim.wtPoserep = wrep;    
    optim.localModelPosePrior_Pos   =  nnrep'; %sknn'; 
    [optim.coeffs_Pos,score_Pos]    = princomp2(optim.localModelPosePrior_Pos);
    optim.meanVec_Pos               = mean(optim.localModelPosePrior_Pos)';%rec(:,f);%
    covMatPosePrior_Pos             = computeCovMat(optim.localModelPosePrior_Pos,optim.nrOfSVPosePriorP);
    optim.invCovMatPosePrior_Pos    = inv(covMatPosePrior_Pos);
    
    startValue       = score_Pos(1,1:optim.nrOfPrinComps);
    
    %     lb = min([score_Pos(:,1:optim.nrOfPrinComps)*lbb; score_Pos(:,1:optim.nrOfPrinComps)*ubb]);
    %     ub = max([score_Pos(:,1:optim.nrOfPrinComps)*lbb; score_Pos(:,1:optim.nrOfPrinComps)*ubb]);
    Xo = lsqnonlin(@(x) objfunLocal(x,optim,cm),startValue,lb,ub,optLSQ);
    recOpt(:,f) = optim.coeffs_Pos(:,1:optim.nrOfPrinComps) * Xo' + optim.meanVec_Pos;
    wtidx = [];
    w = [];
    sknn = [];
    optim.limlen = [];
    fprintf('\b\b\b\b');
end

fprintf('\b done \n');
toc

recOpt          = H_rigidTransformKnn(recOpt,motGT);
motrecOpt       = H_mat2cellMot(recOpt,motGT);
[er.er3DPoseOpt, er.er3DPoseOpt.std] = H_cal3DError(motrecOpt,motGT,erJoints);
disp('3D pose error per every five frames : ');
disp(er.er3DPoseOpt.errFr1_5(1,1));

end

function f = objfunLocal(x,optim,cm)
%% local Objective functions
pos_curr    = optim.coeffs_Pos(:,1:optim.nrOfPrinComps) * x' + optim.meanVec_Pos;

%% Prior pose term
e_pose      = computePrior_local(optim.localModelPosePrior_Pos',pos_curr,optim.wtPoserep,optim.jointWeights,3,optim.expMPrior);
e_pose      = e_pose/sqrt(numel(e_pose));
%% control term
est3d       = H_regularize(pos_curr);
est3d       = optim.camMtx * est3d;
est2d       = project_points2Short(est3d,cm.omc_ext,cm.Tc_ext,cm.fc,cm.cc,cm.kc,cm.alpha_c);
est2d       = reshape(est2d,[],1);
e_control   = optim.estP2D(optim.cJidx2) - est2d(optim.cJidx2);

e_control = reshape(e_control,2,numel(e_control)/2);
e_control = sqrt(sum(e_control.^2));
e_control = reshape(e_control,[],1);

e_control   = e_control /sqrt( numel(e_control)); %
for k = 1:length(optim.limlenIdx)
     limlen(k,1) = sqrt(sum((pos_curr(optim.limlenIdx(k,1:3)) - pos_curr(optim.limlenIdx(k,4:6))).^2));
end
e_limb     = optim.limlen - limlen(:,ones(1,numel(optim.wtPose)));
e_limb     = reshape(e_limb,[],1);
e_limb     = sqrt(e_limb.^2);
e_limb     = e_limb/sqrt(numel(e_limb));

%% Function return vales --------------------------------------------------
f = [optim.w_pose        * e_pose;...
    optim.w_control      * e_control;...
    optim.w_limb         * e_limb...
    ];
end


function est3d = H_regularize(est3d)
%%
est3d           = reshape(est3d,3,[]);
est3d ([1 3],:) = flipud(est3d([1 3],:));    % '321' ---> '123'
est3d ([2 3],:) = flipud(est3d([2 3],:));    % '123' ---> '132'
est3d(4,:)      = 1;
end

function e = computePrior_local(data,query,poseWeights,jointWeights,dofs,exponent)
%%
% Note: Both poseWeights and jointWeights are already normalized!!

diff = data - query(:,ones(1,numel(poseWeights)));
diff = reshape(diff,dofs,numel(diff)/dofs);
diff = sqrt(sum(diff.^2));
diff = reshape(diff,size(data,1)/dofs,numel(poseWeights));
%diff = reshape(diff,size(data,1),numel(poseWeights));

e = jointWeights .* diff;
%e = e.^exponent;
poseWeights = repmat(poseWeights,size(diff,1),[]);
e = e.* poseWeights;
e = reshape(e,[],1);
end


function covMat = computeCovMat(localModel,nrOfSVPosePrior)
%% Compute Covariance Matrix
[U,S,V]     = svd(localModel,'econ');
singVal     = diag(S);
totalNrOfSV = numel(singVal);
sigma       = sum(singVal(nrOfSVPosePrior+1:end).^2)/(totalNrOfSV-nrOfSVPosePrior);
S2          = diag([singVal(1:nrOfSVPosePrior)' sqrt(sigma)*ones(1,(totalNrOfSV-nrOfSVPosePrior))]);
covMat      = V*S2*V'/(totalNrOfSV-1);
end

%==========================================================================

function [er, stdev] = H_cal3DError(motrec,motGT,erJoints)
%% error with input
er.errJnts     = nan(length(erJoints),motrec.nframes);
er.errFr       = nan(motrec.nframes,1);
er.errFrAll    = 0;
inMot          = cell2mat(motrec.jointTrajectories);
mocapGT        = cell2mat(motGT.jointTrajectories);
[er.errJnts, er.errFr, er.errFrAll] = errorHumanEva(inMot,mocapGT,erJoints);
stdev          = std(er.errFr,1);    

er.errJnts          = squeeze(er.errJnts);
er.errFr1_5(1,1)    = mean(er.errFr(1:5:end));
er.errFr1_5(2,1)    = mean(er.errFr(2:5:end));
er.errFr1_5(3,1)    = mean(er.errFr(3:5:end));
er.errFr1_5(4,1)    = mean(er.errFr(4:5:end));
er.errFr1_5(5,1)    = mean(er.errFr(5:5:end));

er.errFr1_5(1,2)    = std(er.errFr(1:5:end),1); % standard ddeviation
er.errFr1_5(2,2)    = std(er.errFr(2:5:end),1);
er.errFr1_5(3,2)    = std(er.errFr(3:5:end),1);
er.errFr1_5(4,2)    = std(er.errFr(4:5:end),1);
er.errFr1_5(5,2)    = std(er.errFr(5:5:end),1);
end

function weights = regulateWeights(w)
weights = w-min(w);
%weights = weights/max(weights);
weights = weights/(max(w) - min(w));

end

function limlenIdx = H_calLimbLengthIdx(allJoints)
%% Limb Lengths ids

limbs1 = {'Left Ankle'; 'Left Knee'; 'Left Hip'; 'Left Shoulder'; 'Left Elbow';
    'Right Ankle'; 'Right Knee'; 'Right Hip'; 'Right Shoulder'; 'Right Elbow';
    'Left Hip'; 'Head'; 'Neck';'Neck'};

limbs2 = {'Left Knee'; 'Left Hip'; 'Left Shoulder'; 'Left Elbow'; 'Left Wrist';
    'Right Knee'; 'Right Hip'; 'Right Shoulder'; 'Right Elbow'; 'Right Wrist';
    'Right Hip'; 'Neck'; 'Left Shoulder';'Right Shoulder'};
for n = 1: length(limbs1)
    idx1 = getSingleJntIdx(limbs1{n},allJoints,3);
    idx2 = getSingleJntIdx(limbs2{n},allJoints,3);
    limlenIdx(n,:) = [idx1; idx2]';
end


end

function recOr = H_Orient(rec,camMtxAllSel)

for f = 1:size(rec,2)
    recTmp = reshape(rec(:,f),3,[]);
    recTmp(4,:)      = 1;
    %[recOr,dYdom,dYdT] = rigid_motion(recTmp,om,T)
    tmp = camMtxAllSel{f} * recTmp;
    recOr(:,f) = tmp(:);
end
end












