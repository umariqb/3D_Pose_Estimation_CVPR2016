function [scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature39( mot )

scale = true;
threshold_vel1 = 2.0;
threshold_vel2 = 2.3;

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));

dataReal = feature_velPoint(mot,'root');
thresh1 = threshold_vel1 * humerus_length;
thresh2 = threshold_vel2 * humerus_length;

if nargout > 4
    dataBool = feature_AK_bool_rootHighVel_robust(mot);
end