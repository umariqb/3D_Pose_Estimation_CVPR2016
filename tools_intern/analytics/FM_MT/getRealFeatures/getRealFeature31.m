function [ scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature31( mot )

scale = true;

threshold_vel1 = -0.35;
threshold_vel2 = -0.5;

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));

dataReal = feature_distPointPlane(mot,'lankle','neck','rankle','root');
thresh1 = threshold_vel1 * humerus_length;
thresh2 = threshold_vel2 * humerus_length;

if nargout > 4
    dataBool = feature_AK_bool_rootBehindFeetLeftRightNeck_robust(mot);
end