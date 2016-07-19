function res=recMotWithPCA(T,skel,mot,varargin)

mot                     = removeOrientation(skel,mot);
mot.rootTranslation     = zeros(3,mot.nframes);
mot.jointTrajectories   = forwardKinematicsQuat(skel,mot);
mot                     = convert2euler(skel,mot);

res.selectedJoints  = [3 4 8 9 15 19 20 26 27];
res.controlJoints   = [3 4 8 9 18 20 25 27];
% res.controlJoints   = 1:31;
res.PCAmatFull      = [];
res.PCAmatSel       = [];
Xr                  = [];
res.kdJoints        = [3 4 8 9 18 20 25 27];
optimStruct.dofs    = [3 0 3 1 2 1 0 3 1 2 1 3 3 3 3 3 3 2 3 1 1 2 1 2 2 3 1 1 2 1 2];

if nargin==4
    res.PCAmatSel   = varargin{1}.PCAmatSel;
    res.PCAmatFull  = varargin{1}.PCAmatFull;
    Xr              = varargin{1}.Xr;
else
    for s=1:T.dimNaturalModes(1)
        for a=1:T.dimNaturalModes(2)
            for r=1:T.dimNaturalModes(3)
                fprintf('%2i%2i%2i\n',s,a,r);
                if (r>1 && strcmp(T.motions{s,a,r},T.motions{s,a,r-1}))
                    disp('Missing motion');
                else
                    [sk,m]          = extractMotion(T,[s,a,r]);
%                     m               = removeOrientation(sk,m);
%                     m.rootTranslation = zeros(3,m.nframes);
%                     m.jointTrajectories = forwardKinematicsQuat(sk,m);
%                     m               = convert2euler(sk,m);
%                     res.PCAmatSel   = [res.PCAmatSel cell2mat(m.rotationEuler(res.selectedJoints))];
                    m.rotationQuat{2}=[];
                    m.rotationQuat{7}=[];
                    res.PCAmatFull  = [res.PCAmatFull cell2mat(m.rotationQuat)];
%                     Xr              = [Xr cell2mat(m.rotationEuler(res.kdJoints))];
                end   
            end
        end
    end
end

% res.nrOfPrinComps       = size(res.PCAmatFull,1);
% % res.nrOfPrinComps       = 28;
% 
% res.struct.PCAmatSel    = res.PCAmatSel;
% res.struct.PCAmatFull   = res.PCAmatFull;
% res.struct.Xr           = Xr;
% 
% k=100;
% 
% lb = [];
% ub = [];
% 
% options = optimset( 'Display','iter',...
%                     'MaxFunEvals',100000,...
%                     'MaxIter',50,...
%                     'TolFun',0.001,...
%                     'PlotFcns', @optimplotx);
% 
% optimStruct.q       = cell(mot.nframes,1);
% optimStruct.q{1}    = cutMotion(mot,1,1);
% optimStruct.q{2}    = cutMotion(mot,2,2);
% 
% res.origMot = mot;
% res.skel    = skel;
% 
% res.recMot  = cutMotion(mot,1,2);
% 
% Xq                      = cell2mat(optimStruct.q{2}.rotationEuler(res.kdJoints));
% [res.nnidx, res.dists]  = annquery(Xr, Xq, k);
% res.PCAmatFullKD        = res.PCAmatFull(:,res.nnidx');
% res.PCAmatSelKD         = res.PCAmatSel(:,res.nnidx');
% [res.coeffsFullKD,res.scoreFullKD]  = princomp(res.PCAmatFullKD');
% [res.coeffsSelKD,res.scoreSelKD]    = princomp(res.PCAmatSelKD');
% res.meanFullKD          = mean(res.PCAmatFullKD,2);
% res.meanSelKD           = mean(res.PCAmatSelKD,2);
% res.coeffsFullKDTrunc   = res.coeffsFullKD(:,1:res.nrOfPrinComps);
% res.scoreFullKDTrunc    = res.scoreFullKD(:,1:res.nrOfPrinComps);
% 
% euler_curr              = cell2mat(optimStruct.q{2}.rotationEuler);
% 
% startValue  = (euler_curr(4:end) - res.meanFullKD)' * pinv(res.coeffsFullKDTrunc');
% 
% for i=3:10 %mot.nframes
%     fprintf('Reconstructing frame %i\n',i);
%     
%     optimStruct.frame       = i;
%     optimStruct.q_orig      = cutMotion(res.origMot,i,i);
%     
%     X                       = lsqnonlin(@(x) objfunPCAlocal(x,res,optimStruct),startValue,lb,ub,options);
%     
%     euler_curr              = [zeros(3,1); res.coeffsFullKDTrunc * X' + res.meanFullKD];
%     
%     Xq                      = cell2mat(optimStruct.q{i-1}.rotationEuler(res.kdJoints));
%     [res.nnidx, res.dists]  = annquery(Xr, Xq, k);
%     res.PCAmatFullKD        = res.PCAmatFull(:,res.nnidx');
%     res.PCAmatSelKD         = res.PCAmatSel(:,res.nnidx');
%     [res.coeffsFullKD,res.scoreFullKD]  = princomp(res.PCAmatFullKD');
%     [res.coeffsSelKD,res.scoreSelKD]    = princomp(res.PCAmatSelKD');   
%     res.meanFullKD          = mean(res.PCAmatFullKD,2);
%     res.meanSelKD           = mean(res.PCAmatSelKD,2);
%     res.coeffsFullKDTrunc   = res.coeffsFullKD(:,1:res.nrOfPrinComps);
%     res.scoreFullKDTrunc    = res.scoreFullKD(:,1:res.nrOfPrinComps);
%     
%     startValue              = (euler_curr(4:end) - res.meanFullKD)' * pinv(res.coeffsFullKDTrunc');
%     
%     optimStruct.q{i}        = buildMotFromEulers(euler_curr,skel,optimStruct.dofs);
%     res.recMot              = addFrame2Motion(res.recMot,optimStruct.q{i}); 
% end
% 
% end
% %% function objfunPCAlocal
% 
% function f = objfunPCAlocal(x,res,optimStruct)
% 
%     euler_curr  = [zeros(3,1); res.coeffsFullKDTrunc * x' + res.meanFullKD];
%     
%     q_curr      = buildMotFromEulers(euler_curr,res.skel,optimStruct.dofs);
%     
%     euler_currSel = cell2mat(q_curr.rotationEuler(res.selectedJoints));
%     
%     % ------- control term ----------
%     nrOfDOFs = q_curr.njoints*3;
%     
%     e_control = sum((...
%                                 cell2mat(q_curr.jointTrajectories(res.controlJoints))...
%                               - cell2mat(optimStruct.q_orig.jointTrajectories(res.controlJoints))...
%                      ).^2) / nrOfDOFs;
%     
% 
%     % ------- smoothness ------------
% 
%     nrOfDOFs = q_curr.njoints*3;
%     e_smooth = sum((...
%                                 cell2mat(q_curr.jointTrajectories)...
%                           - 2 * cell2mat(optimStruct.q{optimStruct.frame-1}.jointTrajectories)...
%                           +     cell2mat(optimStruct.q{optimStruct.frame-2}.jointTrajectories)...
%                    ).^2) / nrOfDOFs;
% 
%     % ------- prior -----------------
%     
%     e_prior = (euler_currSel-res.meanSelKD)'...
%                 * inv(cov(res.PCAmatSelKD'))...
%                 * (euler_currSel-res.meanSelKD)...
%                 / length(euler_currSel);
%     
%     % ------- overall error --------
%     
%     % weights
%     control_w   = 100; 
%     smooth_w    = 1; 
%     prior_w     = 1;
%     
%     f =  control_w * e_control ...
%         + smooth_w * e_smooth ...
%         + prior_w  * e_prior;
%  
% end
% 
% %%
% 
% function q_curr = buildMotFromEulers(euler_curr,skel,dofs)
%     q_curr                      = emptyMotion;
%     q_curr.njoints              = 31;
%     q_curr.nframes              = 1;
%     q_curr.rotationEuler        = mat2cell(euler_curr,dofs);
%     q_curr.rootTranslation      = [0;0;0];
%     q_curr                      = convert2quat(skel,q_curr);
%     q_curr.jointTrajectories    = forwardKinematicsQuat(skel,q_curr);
%     q_curr.boundingBox          = computeBoundingBox(q_curr);
% end