%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function recMotNG (REConstruct MOTion using Neighbour Graph)
%
% res = recMotNG(skel,mot,data)
%
% input:
% - skel: skeleton struct
% - mot:  mot struct
% - data: struct containing fields 'nGraph', 'quat' and 'pos',
%         obtained by data = buildNeighbourGraphC;
% output:
% - res:  struct containing fields 'origmot' and 'recmot'
%
% author: Jochen Tautges (tautges@cs.uni-bonn.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res = recMotNG_new(skel,mot,data)

% options for reconstruction -------------
% optimStruct.joints          = [4,9,17,18,21,25,28]; % joints simulating control data
optimStruct.joints          = [4,28]; % joints simulating control data

optimStruct.priorJoints     = [3,4,5,8,9,10,12:17,19,20,21,26,27,28]; % joints used for pose prior

optimStruct.nrOfPrinComps   = 64; % number of principal components used to represent poses
k                           = 256; % number of nearest neighbours used to build local model

optimStruct.r               = 32; % number of singular values used for prior term

startFrame                  = 1;
endFrame                    = mot.nframes;

res.w_control       = 1;
res.w_smoothness    = 1;
res.w_prior         = 10;
% ----------------------------------------

optimStruct.w_control       = res.w_control;
optimStruct.w_smoothness    = res.w_smoothness;
optimStruct.w_prior         = res.w_prior;

% options for optimization ---------------
lb = [];
ub = [];
options = optimset( 'Display','iter',...
                    'MaxFunEvals',100000,...
                    'MaxIter',50,...
                    'TolFun',0.01);%,...
%                     'LargeScale','off');%,... % use Levenberg Marquard
%                     'PlotFcns', @optimplotx);
% ----------------------------------------

res.skel                    = skel;
mot                         = cutMotion(mot,startFrame,endFrame);
res.origmot                 = mot;

mot.rootTranslation         = zeros(3,mot.nframes);
mot.rotationQuat{1}(1,:)    = 1;
mot.rotationQuat{1}(2:4,:)  = 0;
mot.jointTrajectories       = forwardKinematicsQuat(skel,mot);
% mot                         = fitRootOrientationsFrameWise(skel,mot);
mot.boundingBox             = computeBoundingBox(mot);


res.recmot              = emptyMotion(mot);
quatrec                 = zeros(size(data.quat,1),mot.nframes);

optimStruct.jointIDX    = jointIDsToMatrixIndices(skel,optimStruct.joints);
optimStruct.priorIDX    = jointIDsToMatrixIndices(skel,optimStruct.priorJoints);
dofs                    = getDOFsFromSkel(skel);

optimStruct.skel        = skel;
optimStruct.posLast     = [];
optimStruct.posLastLast = [];
controlSignal           = cell2mat(mot.jointTrajectories(optimStruct.joints));

% estimating nearest neighbours of 0th frame --------------------
distances = sum(abs(data.pos(optimStruct.jointIDX.pos,:)-repmat(controlSignal(:,1),1,size(data.pos,2))));
[distancesSorted,indicesSorted] = sort(distances);
NNlast                          = indicesSorted(1:k); % indices of NN of last synthesized pose
% ---------------------------------------------------------------

if isempty(optimStruct.nrOfPrinComps)
    optimStruct.nrOfPrinComps = size(data.quat,1);
end

% optimStruct.localModel      = data.quat';
% [optimStruct.coeffs,score]  = princomp2(optimStruct.localModel);
% optimStruct.meanVec         = mean(optimStruct.localModel)';

for i=startFrame:endFrame
    
    counter = i-startFrame+1;
    fprintf('\nReconstructing frame %i (%i/%i)...\n',i,counter,endFrame-startFrame+1);
    
    optimStruct.controlSignal   = controlSignal(:,counter);
    
    NNcandidates        = getNeighboursNGraph(data.nGraph,NNlast);
    fprintf('Number of NN-candidates: %i\n',length(NNcandidates));
    rotData_tmp         = data.quat(optimStruct.jointIDX.quats,NNcandidates);
    posData_tmp         = data.pos(optimStruct.jointIDX.pos,NNcandidates);
    indicesSorted       = sortByQueryMetric(rotData_tmp,posData_tmp,optimStruct.posLast,optimStruct.posLastLast,optimStruct.controlSignal);
    NNlast              = NNcandidates(indicesSorted(1:k));
    
    optimStruct.localModel      = data.quat(:,NNlast)';
    
    [optimStruct.coeffs,score]  = princomp2(optimStruct.localModel);
    optimStruct.meanVec         = mean(optimStruct.localModel)';
    
    [U,S,V]     = svd(optimStruct.localModel(:,optimStruct.priorIDX.quats));
    singVal     = diag(S);
    sigma       = sum(singVal(optimStruct.r+1:end).^2)/(numel(singVal)-optimStruct.r);
    
    S2 = diag([singVal(1:optimStruct.r)' sqrt(sigma)*ones(1,(numel(singVal)-optimStruct.r))]);
    C = V*S2*V'/(numel(singVal)-1);
    
    optimStruct.meanVecPrior    = mean(optimStruct.localModel(:,optimStruct.priorIDX.quats))';
    optimStruct.priorFactor     = inv(C); 
    
    if counter==1
        % choose x of nearest neighbour as startvalue
        startValue                  = score(1,1:optimStruct.nrOfPrinComps); 
    else
        % choose x of last reconstructed pose as startvalue
        startValue = (optimStruct.coeffs(:,1:optimStruct.nrOfPrinComps) \ (quatrec(:,counter-1) - optimStruct.meanVec))';
    end
    
    % optimization -------------------------------------
    X = lsqnonlin(@(x) objfunLocal(x,optimStruct),startValue,lb,ub,options);
    % --------------------------------------------------
    
    quatrec(:,counter) = optimStruct.coeffs(:,1:optimStruct.nrOfPrinComps) * X' + optimStruct.meanVec;
    
    if ~isempty(optimStruct.posLast)
        optimStruct.qLastLast = optimStruct.qLast;
        optimStruct.qLast     = quatrec(:,counter);
        optimStruct.summand     = - 2*optimStruct.qLast + optimStruct.qLastLast;
    else
        optimStruct.qLast     = quatrec(:,counter);
    end
    
end

res.recmot.rootTranslation      = res.origmot.rootTranslation;
res.recmot.rotationQuat         = mat2cell(quatrec,dofs.quat,i);
res.recmot.rotationQuat{1}      = res.origmot.rotationQuat{1};
res.recmot.jointTrajectories    = C_forwardKinematicsQuat(skel,res.recmot);
res.recmot.boundingBox          = computeBoundingBox(res.recmot);
res.recmot                      = convert2euler(skel,res.recmot);

res.dist = compareMotions08(skel,res.origmot,res.recmot);

end

%% local functions
function f = objfunLocal(x,optimStruct)

    quat_curr   = optimStruct.coeffs(:,1:optimStruct.nrOfPrinComps) * x' + optimStruct.meanVec;
    mot_curr    = buildMotFromRotData(quat_curr,optimStruct.skel);
    pos_curr    = cell2mat(mot_curr.jointTrajectories);
    
    % control term --------------------------------------------------------
    e_control   = optimStruct.controlSignal - pos_curr(optimStruct.jointIDX.pos);
    
    e_control   = e_control / sqrt(numel(e_control));
    % ---------------------------------------------------------------------
    
    % smoothness term -----------------------------------------------------
    if ~isempty(optimStruct.posLastLast)
        e_smoothness    = pos_curr + optimStruct.summand;
    else 
        e_smoothness    = zeros(size(pos_curr));
    end
    e_smoothness = e_smoothness / sqrt(numel(e_smoothness));
    % ---------------------------------------------------------------------
    
    % prior term ----------------------------------------------------------
    diffVec = quat_curr(optimStruct.priorIDX.quats) - optimStruct.meanVecPrior;
    e_prior =     diffVec'...
                * optimStruct.priorFactor...
                * diffVec;   
    
    e_prior = e_prior / numel(diffVec);
    % ---------------------------------------------------------------------
    
    f = [optimStruct.w_control      * e_control;...
         optimStruct.w_smoothness   * e_smoothness;...
         optimStruct.w_prior        * e_prior];

%      b = [sum((w_control * e_control).^2),...
%           sum((w_smoothness * e_smoothness).^2),...
%           sum((w_prior * e_prior).^2)];
     
end