function [ scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature21( mot )

scale = false;
threshold_vel1 = [0 120];
threshold_vel2 = [0 110];

dataReal = feature_angleJoint(mot,'lhip','lankle','lknee');
thresh1 = threshold_vel1(2);
thresh2 = threshold_vel2(2);

if nargout > 4
    dataBool = feature_AK_bool_kneeLeftBent_robust(mot);
end