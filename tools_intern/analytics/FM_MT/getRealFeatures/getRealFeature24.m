function [ scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature24( mot )

scale = true;
threshold_vel1 = 1.3;
threshold_vel2 = 1.5;

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));

dataReal = feature_velRelPointNormalPlane(mot,'lhip','rhip','rhip','rankle',100) - feature_velRelPointNormalPlane(mot,'lhip','rhip','rhip','lankle',100);
thresh1 = threshold_vel1 * humerus_length;
thresh2 = threshold_vel2 * humerus_length;

if nargout > 4
    dataBool = feature_AK_bool_feetMoveApartRelHips_robust(mot);
end