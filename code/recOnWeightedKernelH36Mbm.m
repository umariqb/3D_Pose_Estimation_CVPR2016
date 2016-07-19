function [er, optim, opts, motrecOpt] = recOnWeightedKernelH36Mbm(opts)
%% options updates
close all;
% opts_bak = opts;
% if(nargin == 0)
%     [opts, skel] = initializeOpts;
% elseif(nargin == 1)
%     [opts, skel] = initializeOpts(varargin{1});
% elseif(nargin == 2)
%     [opts, skel] = initializeOpts(varargin{1},varargin{2});
% elseif(nargin == 3)
%     [opts, skel] = initializeOpts(varargin{1},varargin{2},varargin{3});
% elseif(nargin == 4)
%     [opts, skel] = initializeOpts(varargin{1},varargin{2},varargin{3},varargin{4});
% elseif(nargin == 5)
%     [opts, skel] = initializeOpts(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5});
% else
%     disp('H_error: H_retMain... wring number of input arguments');
% end
% round = 1;
% opts.round = round;
% 
% opts.database = 'Human36Mbm'; %'Human36Mbm'\'CMU_H36M';
% opts.exp      = 'nogt';   % nogt/gt2D/gt3D
% opts.loadPath  = fullfile('../Data/');
% opts.loadIdxPath  = fullfile('../Data/');
% opts.loadInPath  = fullfile('../Data/');
% opts.saveResPath = fullfile('../Data/');
if ~exist(opts.saveResPath,'dir')
    mkdir(opts.saveResPath);
end

%% Loading input anf GT

[motIn, motInN, opts] = loadnPrepareQMot(opts);
load(fullfile([opts.loadPath 'motGT_' opts.subject '_' opts.actName ])); %gt
if(isfield(opts, 'extractFrameNum') == 1)
    motGT = extractSingleGT(motGT, opts.extractFrameNum);
end
estP2D = cell2mat(motIn.jointTrajectories2DF);
cm = motIn.camera;
%% Loading nn
%shape    = {'upper';'lower';'left';'right';'pose'};
try
    shape = motIn.bodyTypeOrder;
catch
    disp('Please load right input which has weighted knn ...');
end
for h = 1:length(shape)
    loadIdxPath           = opts.loadIdxPath;
    idName                = [opts.subject '_Activity_All_C2_256_' shape{h} '_obj.mat'];
    load([loadIdxPath idName]);
    objAll{h,1}.obj       = obj;
    objAll{h,1}.knn       = opts.knn;
    objAll{h,1}.knnJoints = opts.allJoints;
    objAll{h,1}.bodyType  = shape{h};
    
    idNameCM              = [opts.subject '_Activity_All_C2_256_' shape{h} '_camMtx.mat'];
    load([loadIdxPath idNameCM]);
    camMtxAll{h,1}        = camMtx;
    
    loadIdxPath           = opts.loadIdxPath;
    
    opts.cJno = getShapeJointNum(shape{h},opts.inputDB);
    [opts.allJoints, opts.cJoints] = getJointsHE (opts.inputDB,opts.database,opts.cJno,shape{h});
    opts = getJointsIdx(opts);
    jnts.cJidx{h,1}   = opts.cJidx;
    jnts.cJidx2{h,1}  = opts.cJidx2;
    jnts.cJidx3{h,1}  = opts.cJidx3;
end
%% reconstruction options
erJoints               = 14;
selknn                 = 256;
nknn                   = 64;
optim.nknn             = nknn;

optim.nrOfSVPosePriorP = 18;          %25 %30                                  % number of singular values used for pose term
optim.nrOfPrinComps    = 18;          %25 %30
optim.w_pose           = .35;        %20   .60
optim.w_control        = .55;        %10   .45
optim.w_limb           = .065;         %10  .05

fprintf('%3d ', optim.w_pose  );
fprintf('%3d ', optim.w_control);
fprintf('%3d ', optim.w_limb  );
disp(' . . . done');

optim.expPPrior        = 0.5;
optim.expMPrior        = 0.5;
optim.expSmooth        = 0.5;
optim.expControl       = 0.5;
optim.jointWeights     = 1;
optim.jointWeights2D   = 1;

optLSQ      = optimset( 'Display','none',... %'iter',
    'MaxFunEvals',100000,...
    'MaxIter',1000,...
    'TolFun',0.001,...
    'TolX',0.001,...
    'LargeScale','on',...
    'Algorithm','levenberg-marquardt');
lb = [];
ub = [];
%% Reconstruction

bt     = 'all';   % all/pose

optim.limlenIdx = H_calLimbLengthIdx(opts.allJoints);
tic
fprintf('Reconstruction: Frame no. ...     ');
for f = 1:motIn.nframes
    fprintf('%3d ', f);
    if(strcmp(bt,'all'))
        sObj = objAll{motIn.bodyType(f),1};
    else
        sObj = objAll{1,1};
    end
    sknn = sObj.obj.data(:,f);
    sknn = reshape(sknn,3*length(opts.allJoints),[]);
    sknn = sknn(:,1:selknn);
    
    for j = 1:length(optim.limlenIdx)
        optim.limlen(j,:) = sqrt(sum((sknn(optim.limlenIdx(j,1:3),:) - sknn(optim.limlenIdx(j,4:6),:)).^2));  
    end
    w            = motIn.knnWts(1:selknn,f)';
    ind          = find(w>1);
    w(ind)       = 0;
    w            = regulateWeights(w);
    [~, wtidx]   = sort(w,'descend');
    w            = w(wtidx(1:nknn));
    
    optim.limlen = optim.limlen(:,wtidx(1:nknn));
    sknn         = sknn(:,wtidx(1:nknn));
     opts.bodyType = sObj.bodyType;
    opts.cJno = getShapeJointNum(opts.bodyType,opts.inputDB);
    [opts.allJoints, opts.cJoints] = getJointsHE (opts.inputDB,opts.database,opts.cJno,opts.bodyType);
    opts = getJointsIdx(opts);

    optim.estP2D = estP2D(:,f);    
    if(strcmp(bt,'all'))
        optim.camMtx = cell2mat(camMtxAll{motIn.bodyType(f),1}(f,1));
    else
        optim.camMtx = cell2mat(camMtxAll{1,1}(f,1));
    end
    optim.cJidx2 = opts.cJidx2;
    optim.wtPose = w;

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
    optim.localModelPosePrior_Pos   =  nnrep'; %sknn'; %
    [optim.coeffs_Pos,score_Pos]    = princomp2(optim.localModelPosePrior_Pos);
    optim.meanVec_Pos               =  mean(optim.localModelPosePrior_Pos)';%rec(:,f);%
    covMatPosePrior_Pos             = computeCovMat(optim.localModelPosePrior_Pos,optim.nrOfSVPosePriorP);
    optim.invCovMatPosePrior_Pos    = inv(covMatPosePrior_Pos);
    if f > 1
        startValue = (optim.coeffs_Pos(:,1:optim.nrOfPrinComps) \ (recOpt(:,f - 1) - optim.meanVec_Pos))';
    else
        startValue = score_Pos(1,1:optim.nrOfPrinComps);
    end
    startValue     = score_Pos(1,1:optim.nrOfPrinComps);
    
    Xo             = lsqnonlin(@(x) objfunLocal(x,optim,cm),startValue,lb,ub,optLSQ);
    recOpt(:,f)    = optim.coeffs_Pos(:,1:optim.nrOfPrinComps) * Xo' + optim.meanVec_Pos;    
    wtidx = [];
    w = [];
    sknn = [];
    optim.limlen = [];
    fprintf('\b\b\b\b');
end

fprintf('\b done \n');
toc
%% Reconstruct with kernal approach

recOpt          = H_rigidTransformKnn(recOpt,motGT);
motrecOpt       = H_mat2cellMot(recOpt,motGT);
[er.er3DPoseOpt, er.er3DPoseOpt.std] = H_cal3DError(motrecOpt,motGT,erJoints);
disp(er.er3DPoseOpt.errFrAll);
%motPlay3D('Human36Mbm',motrecOpt);
end

function f = objfunLocal(x,optim,cm)
pos_curr    = optim.coeffs_Pos(:,1:optim.nrOfPrinComps) * x' + optim.meanVec_Pos;
e_pose      = computePrior_local(optim.localModelPosePrior_Pos',pos_curr,optim.wtPoserep,optim.jointWeights,3,optim.expMPrior);
e_pose      = e_pose/sqrt(numel(e_pose));
est3d       = H_regularize(pos_curr);

[est2d,~]   = H_proj(optim.camMtx,est3d,cm);
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
f = [optim.w_pose        * e_pose;...
    optim.w_control      * e_control;...
    optim.w_limb         * e_limb...
    ];
end

function est3d = H_regularize(est3d)
%%
est3d           = reshape(est3d,3,[]);
est3d([2 3],:)     = flipud(est3d([2 3],:));
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
stdev          = std(er.errFr,1);    % 

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
%% Normalize weights between 0 - 1
weights = w-min(w);
%weights = weights/max(weights);
weights = weights/(max(w) - min(w));

end

function limlenIdx =H_calLimbLengthIdx(allJoints)
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

function H_motionPlayer(skel,mot1,mot2)
scalingFactor = 10;
for i = 1:mot1.njoints
    mot1.jointTrajectories{i,1}(1,:) = mot1.jointTrajectories{i,1}(1,:)/scalingFactor ;
    mot1.jointTrajectories{i,1}(2,:) = mot1.jointTrajectories{i,1}(2,:)/scalingFactor ;
    mot1.jointTrajectories{i,1}(3,:) = mot1.jointTrajectories{i,1}(3,:)/scalingFactor ;
    
    mot2.jointTrajectories{i,1}(1,:) = mot2.jointTrajectories{i,1}(1,:)/scalingFactor ;
    mot2.jointTrajectories{i,1}(2,:) = mot2.jointTrajectories{i,1}(2,:)/scalingFactor ;
    mot2.jointTrajectories{i,1}(3,:) = mot2.jointTrajectories{i,1}(3,:)/scalingFactor ;
end
mot1.boundingBox = computeBoundingBox(mot1);
mot2.boundingBox = computeBoundingBox(mot2);
motionplayerPro('skel',skel,'mot',{mot1,mot2});
end

function [est2d,j3d] = H_proj(x,est3d,cm)
R      = makehgtform('xrotate',deg2rad(x(1)),'yrotate',deg2rad(x(2)),'zrotate',deg2rad(x(3)));
R      = R(1:3,1:3);
T      = [x(4); x(5); x(6)];
R      = [R T];
j3d    = R*est3d;

% T      = T';
% j3d    = est3d(1:3,:);
[est2d, ~] = ProjectPointRadial(j3d', cm.R, cm.T, cm.f, cm.c, cm.k, cm.p);
est2d = est2d';

end










