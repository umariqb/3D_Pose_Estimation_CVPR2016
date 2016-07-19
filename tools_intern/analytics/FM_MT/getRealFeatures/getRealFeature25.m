function [ scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature25( mot )

scale = true;
threshold_vel1 = 2;
threshold_vel2 = 2.5;

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));

dataReal = min(feature_velPoint(mot,'rtoes','',100), feature_velPoint(mot,'rankle','',100));   % not quite correct...
thresh1 = threshold_vel1 * humerus_length;
thresh2 = threshold_vel2 * humerus_length;

if nargout > 4
    dataBool = feature_AK_bool_footRightHighVel_robust(mot);
end