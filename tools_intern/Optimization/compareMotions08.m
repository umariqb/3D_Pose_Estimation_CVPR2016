function res = compareMotions08(skel1,mot1,skel2,mot2)

% res.regardedJoints=[3:5,8:10,12:17,19:21,26:28];%default
res.regardedJoints=[25 26 27 14 18 19 20 8 9 3 4];% for cleaning comparison 2011
%Joints [LFoot=4, RFoot=9, LHand=21, RHand=28, LKnee=3, RKnee=8, LElbow=19, RElbow=26, Head=17]

% res.regardedJoints=mot1.animated';

doDTW = false;

if doDTW
    [D,w] = pointCloudDTW_pos(mot1,mot2,2);
    mot2  = warpMotion(w,skel2,mot2);
end

% if isempty(cell2mat(mot1.rotationEuler(mot1.animated)))
%     mot1 = C_convert2euler(skel1,mot1);
% end
% 
% if isempty(cell2mat(mot2.rotationEuler(mot2.animated)))
%     mot2 = C_convert2euler(skel2,mot2);
% end
% 
% % eulermatrix1 = cell2mat(mot1.rotationEuler(res.regardedJoints));
% % eulermatrix2 = cell2mat(mot2.rotationEuler(res.regardedJoints));
% % diff = eulermatrix1-eulermatrix2;
% 
% % res.euler_L1_framewise = mean(sum(abs(diff)));
% % res.euler_L2_framewise = mean(sqrt(sum(diff.^2)));
% 
% % res.euler_L1_jointwise = mean(mean(cell2mat(...
% %     cellfun(@(x,y) sum(abs(x-y),1),mot1.rotationEuler(res.regardedJoints),mot2.rotationEuler(res.regardedJoints),'UniformOutput',false))));
%                         
% res.euler_degrees = mean(mean(cell2mat(...
%     cellfun(@(x,y)...
%     sqrt(sum((x-y).^2,1)),...
%     mot1.rotationEuler(res.regardedJoints),mot2.rotationEuler(res.regardedJoints),'UniformOutput',false))));    
% 
% % res.euler_degrees2 = mean(sum(cell2mat(...
% %     cellfun(@(x,y)...
% %     sqrt(sum((x-y).^2,1)),...
% %     mot1.rotationEuler(res.regardedJoints),mot2.rotationEuler(res.regardedJoints),'UniformOutput',false)))/59);     
% 
% % res.euler_degrees3 = mean(mean(...
% %     abs(cell2mat(mot1.rotationEuler(res.regardedJoints))...
% %     -cell2mat(mot2.rotationEuler(res.regardedJoints))),2));     
% 
% res.quat_degrees = mean(mean(cell2mat(...
%     cellfun(@(x,y)...
%     real(acosd(dot(quatnormalize(x),quatnormalize(y))))*2,...
%     mot1.rotationQuat(res.regardedJoints),mot2.rotationQuat(res.regardedJoints),'UniformOutput',false))));
% 
P = reshape(cell2mat(mot1.jointTrajectories(res.regardedJoints)),3,numel((res.regardedJoints))*mot1.nframes);
Q = reshape(cell2mat(mot2.jointTrajectories(res.regardedJoints)),3,numel((res.regardedJoints))*mot2.nframes);
d = pointCloudDist_modified(P,Q,'pos');

res.pointCloud_perFrame = mean(reshape(sqrt(sum(d.^2))*2.54,numel(res.regardedJoints),mot1.nframes));
res.std_pointCloud      = std(res.pointCloud_perFrame);
res.pointcloud_cm       = mean(res.pointCloud_perFrame);

res.dist_cm = mean(mean(sqrt((P-Q).^2)));


%%


% mot2_fit = fitMotFrameWise(skel2,mot1,mot2);
% 
% P = reshape(cell2mat(mot1.jointTrajectories),3,mot1.njoints*mot1.nframes);
% Q = reshape(cell2mat(mot2_fit.jointTrajectories),3,mot2.njoints*mot2.nframes);
% d = pointCloudDist_modified(P,Q,'pos');
% 
% res.pointCloud_perFrame2 = mean(reshape(sqrt(sum(d.^2))*2.54,mot1.njoints,mot1.nframes));
% % res.std_pointCloud2      = std(res.pointCloud_perFrame2);
% res.pointcloud_cm2       = mean(res.pointCloud_perFrame2);
% 
% mot1_0 = mot1;
% mot2_0 = mot2;
% 
% mot1_0.rootTranslation(:,:)=0;
% mot2_0.rootTranslation(:,:)=0;
% mot1_0.jointTrajectories = forwardKinematicsQuat(skel1,mot1_0);
% mot2_0.jointTrajectories = forwardKinematicsQuat(skel2,mot2_0);
% 
% P = reshape(cell2mat(mot1_0.jointTrajectories),3,mot1.njoints*mot1.nframes);
% Q = reshape(cell2mat(mot2_0.jointTrajectories),3,mot2.njoints*mot2.nframes);
% d = pointCloudDist_modified(P,Q,'pos');
% 
% res.pointCloud_perFrame3 = mean(reshape(sqrt(sum(d.^2))*2.54,mot1.njoints,mot1.nframes));
% % res.std_pointCloud3      = std(res.pointCloud_perFrame3);
% res.pointcloud_cm3       = mean(res.pointCloud_perFrame3);
% 
% angles1 = computeAngles(skel1,mot1,res.regardedJoints);
% angles2 = computeAngles(skel2,mot2,res.regardedJoints);
% 
% % res.angles_degrees = mean(mean(abs(cell2mat(angles1)-cell2mat(angles2))));
% angles_degrees = cell(numel(res.regardedJoints),1);
% angles_degrees_weighted = cell(numel(res.regardedJoints),1);
% weights = [];
% for i=res.regardedJoints
%     
%     if ~isempty(angles1{i}) && ~isempty(angles2{i})
%         weights = [weights skel1.nodes(i).length];
%         angles_degrees{i,1} = mean(abs(angles1{i} - angles2{i}));
%         angles_degrees_weighted{i,1} = mean(angles_degrees{i} * weights(end));
%     end
%   
% end
% 
% res.angles_degrees = mean(cell2mat(angles_degrees));
% res.angles_degrees_weighted = sum(cell2mat(angles_degrees_weighted))/sum(weights);

% res.crossProduct = compareMotionsCrossProduct2(mot1,mot2,res.regardedJoints);
