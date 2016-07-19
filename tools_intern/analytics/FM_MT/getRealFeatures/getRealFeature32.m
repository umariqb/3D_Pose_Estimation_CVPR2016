function [scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature32( mot )

scale = false;
threshold_vel1 = [90-30, 90+30];
threshold_vel2 = [90-20, 90+20];

dataReal = feature_angleVectorNormalPlane(mot,'root','neck',[0;1;0]);
thresh1 = threshold_vel1(1);
thresh2 = threshold_vel1(2);

if nargout > 4
    dataBool = feature_AK_bool_spineHorizontalRelY_robust(mot);
end