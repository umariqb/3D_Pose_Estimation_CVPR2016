% function recMotWithPCA(dataMat,skel,mot,dataRep)
%
% dataMat   = dofs x frames
% skel      = skel struct of original motion
% mot       = mot struct of original motion
% dataRep   = 'quat' or 'euler'

function res = recMotWithPCAmat(dataMat,skel,mot,dataRep)

mot.rootTranslation     = zeros(3,mot.nframes);
mot                     = fitRootOrientationsFrameWise(skel,mot);
mot.boundingBox         = computeBoundingBox(mot);

res.controlJoints       = [4 9 20 27];
res.kdJoints            = [3 4 8 9 19 20 26 27];

Xr                      = [];

switch dataRep
    case 'euler' 
        optimStruct.dofs            = [3 0 3 1 2 1 0 3 1 2 1 3 3 3 3 3 3 2 3 1 1 2 1 2 2 3 1 1 2 1 2];
    case 'quat'
        optimStruct.dofs            = [4 0 4 4 4 4 0 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4];
end
dofsCum = [0 cumsum(optimStruct.dofs)];

for i=res.kdJoints
    Xr                  = [Xr ; dataMat(dofsCum(i)+1:dofsCum(i+1),:)];
end

% --------------------------------------------
% maximum number of nearest neightbours: size(dataMat,2);
res.k                       = size(dataMat,2);
% maximum number of nearest neighbours for PCA: res.k;
% res.kForOptimization        = 50;
% maximum number of principal components: size(dataMat,1);
res.nrOfPrinComps           = 30;
res.nrOfPrinCompsForCovMat  = 20;
% ---------------------------------------------

lb = [];
ub = [];

options = optimset( 'Display','iter',...
                    'MaxFunEvals',100000,...
                    'MaxIter',100,...
                    'TolFun',0.01);%,...
%                     'PlotFcns', @optimplotx);
                
startFrame  = 1;
% endFrame    = mot.nframes;
endFrame    = 20;

optimStruct.dataRep             = dataRep;
optimStruct.q                   = cell(mot.nframes,1);
optimStruct.q{startFrame}       = cutMotion(mot,startFrame,startFrame);
optimStruct.q{startFrame+1}     = cutMotion(mot,startFrame+1,startFrame+1);

res.recMot  = cutMotion(mot,startFrame,startFrame+1);

switch dataRep
    case 'euler'
        angles_curr = cell2mat(optimStruct.q{startFrame+1}.rotationEuler);
        Xq          = cell2mat(optimStruct.q{startFrame+1}.rotationEuler(res.kdJoints));
    case 'quat'
        angles_curr = cell2mat(optimStruct.q{startFrame+1}.rotationQuat);
        Xq          = cell2mat(optimStruct.q{startFrame+1}.rotationQuat(res.kdJoints));
end
        
[nnidx,dists]                           = annquery(Xr, Xq, res.k);
optimStruct.dataMatKD                   = dataMat(:,nnidx');
[optimStruct.coeffs,optimStruct.score]  = princomp(optimStruct.dataMatKD');
optimStruct.meanVec                     = mean(optimStruct.dataMatKD,2);
% optimStruct.dataMatKD == 
% optimStruct.coeffs * optimStruct.score' + repmat(optimStruct.meanVec,1,res.k)
optimStruct.priorFactor                 =     pinv(optimStruct.coeffs(:,1:res.nrOfPrinCompsForCovMat)')...
                                                * inv(cov(optimStruct.score(:,1:res.nrOfPrinCompsForCovMat)))...
                                                * pinv(optimStruct.coeffs(:,1:res.nrOfPrinCompsForCovMat));
                                            
% s  = (dists(res.kForOptimization)*ones(res.kForOptimization,1)-dists(1:res.kForOptimization));
% w  = s/sum(s);
% angles_curr     = optimStruct.dataMatKD(:,1:res.kForOptimization)*w;

% startValue      = (angles_curr-optimStruct.meanVec)' ...
%                     * pinv(optimStruct.coeffs(:,1:res.nrOfPrinComps)') ...
%                     * pinv(optimStruct.score(1:res.kForOptimization,1:res.nrOfPrinComps));

startValue      = (angles_curr-optimStruct.meanVec)' ...
                    * pinv(optimStruct.coeffs(:,1:res.nrOfPrinComps)');

res.origMot     = cutMotion(mot,startFrame,endFrame);
res.skel        = skel;

for i=startFrame+2:endFrame
    fprintf('\nReconstructing frame %i...\n',i);
    
    optimStruct.frame       = i;
    optimStruct.q_orig      = cutMotion(res.origMot,i,i);
    
    X                       = lsqnonlin(@(x) objfunPCAlocal(x,res,optimStruct),startValue,lb,ub,options);
    
%     angles_curr      =  (X * optimStruct.score(1:res.kForOptimization,1:res.nrOfPrinComps)...
%                            * optimStruct.coeffs(1:res.nrOfPrinComps,:)')'...
%                            + optimStruct.meanVec;
                       
    angles_curr     =  optimStruct.coeffs(:,1:res.nrOfPrinComps) * X'...
                           + optimStruct.meanVec;
    
    optimStruct.q{i}        = buildMotFromAngles(angles_curr,skel,optimStruct.dofs,dataRep);
    res.recMot              = addFrame2Motion(res.recMot,optimStruct.q{i}); 
    save('res','res');
    
    switch dataRep
        case 'euler'
            Xq          = cell2mat(optimStruct.q{i}.rotationEuler(res.kdJoints));
        case 'quat'
            Xq          = cell2mat(optimStruct.q{i}.rotationQuat(res.kdJoints));
    end
    
    [nnidx,dists]                           = annquery(Xr, Xq, res.k);
    optimStruct.dataMatKD                   = dataMat(:,nnidx');
    [optimStruct.coeffs,optimStruct.score]  = princomp(optimStruct.dataMatKD');
    optimStruct.meanVec                     = mean(optimStruct.dataMatKD,2);
    optimStruct.priorFactor                 =     pinv(optimStruct.coeffs(:,1:res.nrOfPrinCompsForCovMat)')...
                                                * inv(cov(optimStruct.score(:,1:res.nrOfPrinCompsForCovMat)))...
                                                * pinv(optimStruct.coeffs(:,1:res.nrOfPrinCompsForCovMat));
                                            
%     s  = (dists(res.kForOptimization)*ones(res.kForOptimization,1)-dists(1:res.kForOptimization));
%     w  = s/sum(s);
%     angles_curr     = optimStruct.dataMatKD(:,1:res.kForOptimization)*w;
    
%     startValue      = ((angles_curr-optimStruct.meanVec)'...
%                     * pinv(optimStruct.coeffs(:,1:res.nrOfPrinComps)'))...
%                     * pinv(optimStruct.score(1:res.kForOptimization,1:res.nrOfPrinComps));
                
    startValue      = (angles_curr-optimStruct.meanVec)' ...
                    * pinv(optimStruct.coeffs(:,1:res.nrOfPrinComps)');
                
end

res.recMot.samplingRate = res.origMot.samplingRate;

end
%% function objfunPCAlocal

function f = objfunPCAlocal(x,res,optimStruct)
    
%     angles_curr     =  (x * optimStruct.score(1:res.kForOptimization,1:res.nrOfPrinComps)...
%                            * optimStruct.coeffs(1:res.nrOfPrinComps,:)')'...
%                            + optimStruct.meanVec;

    angles_curr     =  optimStruct.coeffs(:,1:res.nrOfPrinComps) * x'...
                           + optimStruct.meanVec;
                       
    q_curr          = buildMotFromAngles(angles_curr,res.skel,optimStruct.dofs,optimStruct.dataRep);
    
    % ------- control term ----------

    e_control =     cell2mat(q_curr.jointTrajectories(res.controlJoints))...
                  - cell2mat(optimStruct.q_orig.jointTrajectories(res.controlJoints));
              
%     e_control = mean(e_control.^2);

    % ------- smoothness ------------
               
    e_smooth =      cell2mat(q_curr.jointTrajectories)...
              - 2 * cell2mat(optimStruct.q{optimStruct.frame-1}.jointTrajectories)...
              +     cell2mat(optimStruct.q{optimStruct.frame-2}.jointTrajectories);
   
%     e_smooth = mean(e_smooth.^2); 

    % ------- prior -----------------
    
    e_prior =     (angles_curr-optimStruct.meanVec)'...
                * optimStruct.priorFactor...
                * (angles_curr-optimStruct.meanVec);
            
%     e_prior = e_prior / length(angles_curr);
    
    % ------- overall error --------
    
    % weights
    control_w   = 1   / numel(e_control); 
    smooth_w    = 1   / numel(e_smooth); 
    prior_w     = 1   / numel(e_prior);
    
%     f =  control_w * e_control ...
%         + smooth_w * e_smooth ...
%         + prior_w  * e_prior;
    
    f = [control_w * e_control(:);... 
         smooth_w  * e_smooth(:);...
         prior_w   * e_prior(:)];
     
%      bar([control_w*sum(e_control.^2) smooth_w*sum(e_smooth.^2) prior_w*e_prior^2]);
%      drawnow();
end

%% function buildMotFromAngles

function q_curr = buildMotFromAngles(angles_curr,skel,dofs,dataRep)
    
    q_curr                      = emptyMotion;
    q_curr.njoints              = 31;
    q_curr.nframes              = 1;
    q_curr.rootTranslation      = [0;0;0];
    
    switch dataRep
        case 'euler'
            q_curr.rotationEuler        = mat2cell(angles_curr,dofs);
            q_curr                      = convert2quat(skel,q_curr);
        case 'quat'
            q_curr.rotationQuat         = mat2cell(angles_curr,dofs);
%             q_curr                      = convert2euler(skel,q_curr);
    end
     
    q_curr.jointTrajectories    = forwardKinematicsQuat(skel,q_curr);
    q_curr.boundingBox          = computeBoundingBox(q_curr);
end