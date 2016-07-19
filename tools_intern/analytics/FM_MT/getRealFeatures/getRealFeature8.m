function [ scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature8( mot )

scale = false;
range1 = [0 120];
range2 = [0 110];

dataReal = feature_angleJoint(mot,'lshoulder','lwrist','lelbow');
thresh1 = range1(2);
thresh2 = range2(2);

if nargout > 4
    dataBool = feature_AK_bool_elbowLeftBent_robust(mot);
end