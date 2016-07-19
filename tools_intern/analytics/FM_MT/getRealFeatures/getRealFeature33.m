function [scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature33( mot )

scale = true;
threshold_vel1 = 1.4;
threshold_vel2 = 1.2;

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));

dataReal = mot.jointTrajectories{trajectoryID(mot,'rfingers')}(2,:) - feature_YBodyMin(mot,{'rfingers','rwrist'});;
thresh1 = threshold_vel1 * humerus_length;
thresh2 = threshold_vel2 * humerus_length;

if nargout > 4
    dataBool = feature_AK_bool_handRightLowRelYBodyMin_robust(mot);
end