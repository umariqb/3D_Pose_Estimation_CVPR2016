function [ scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature9( mot )

scale = true;
shoulder_width = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lshoulder')}(:,1)).^2));

thresh1 = 2 * shoulder_width;
thresh2 = 2.5 * shoulder_width;

dataReal = feature_distPointNormalPlane(mot,'lshoulder','rshoulder','lwrist','rwrist');

if nargout > 4
    dataBool = feature_AK_bool_handsApartRelShoulders_robust(mot);
end