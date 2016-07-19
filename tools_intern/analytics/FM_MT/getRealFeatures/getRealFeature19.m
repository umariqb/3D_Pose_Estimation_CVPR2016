function [ scale, dataReal, thresh1, thresh2, dataBool] = getRealFeature19( mot )

scale = true;
threshold_vel1 = 1.8;
threshold_vel2 = 2.1;

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));
                 
dataReal = feature_distPointNormalPlane(mot,'lhip','rhip','lankle','rankle');
thresh1 = threshold_vel1 * humerus_length;
thresh2 = threshold_vel2 * humerus_length;

if nargout > 4
    dataBool = feature_AK_bool_feetApartRelHips_robust(mot);
end