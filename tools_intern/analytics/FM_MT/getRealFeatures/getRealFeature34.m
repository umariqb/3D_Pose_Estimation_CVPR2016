function [ scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature34( mot )

scale = true;
threshold_vel1 = 1.4;
threshold_vel2 = 1.2;

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));

dataReal = mot.jointTrajectories{trajectoryID(mot,'lfingers')}(2,:) - feature_YBodyMin(mot,{'lfingers','lwrist'});;
thresh1 = threshold_vel1 * humerus_length;
thresh2 = threshold_vel2 * humerus_length;

if nargout > 4
    dataBool = feature_AK_bool_handLeftLowRelYBodyMin_robust(mot);
end
