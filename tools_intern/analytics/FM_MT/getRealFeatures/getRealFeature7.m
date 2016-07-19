function [ scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature7( mot )

scale = false;
range1 = [0 120];
range2 = [0 110];

dataReal = feature_angleJoint(mot,'rshoulder','rwrist','relbow');
thresh1 = range1(2);
thresh2 = range2(2);

if nargout > 4
    dataBool = feature_AK_bool_elbowRightBent_robust(mot);
end