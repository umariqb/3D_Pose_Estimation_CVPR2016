function [ scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature36( mot )

scale = true;
threshold_vel1 = - 0.35;
threshold_vel2 = - 0.4;

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'lshoulder')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lelbow')}(:,1)).^2));

dataReal = feature_distPointPlane( mot, 'rhip', 'lhip', 'neck', 'lshoulder' ) - feature_distPointPlane( mot, 'rhip', 'lhip', 'neck', 'rshoulder' );
thresh1 = threshold_vel1 * humerus_length;
thresh2 = threshold_vel2 * humerus_length;

if nargout > 4
    dataBool = feature_AK_bool_shouldersRotatedLeftRelHip_robust(mot);
end