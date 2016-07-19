function [costs, gradient] = costFunQuat( X )

global VARS_GLOBAL_SKELFIT

jt_goal = VARS_GLOBAL_SKELFIT.jointTrajectories;
rootRotationalOffsetQuat = VARS_GLOBAL_SKELFIT.rootRotationalOffsetQuat;
nodes = VARS_GLOBAL_SKELFIT.nodes;
frame = VARS_GLOBAL_SKELFIT.frame;

rootTranslation = X(1:3)';
% rotationQuat = X(4:length(rotationQuat));

for i=1:VARS_GLOBAL_SKELFIT.nJoints
    rotationQuat{i} = X(4*i: 4*i + 3)';
end


jt_fk = fK_Quat_frame(rotationQuat, rootTranslation, nodes, rootRotationalOffsetQuat);

diff = cell2mat(jt_goal) - cell2mat(jt_fk);
costs = sqrt( dot( diff, diff ) );
gradient = 1;