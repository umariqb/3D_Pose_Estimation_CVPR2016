function [ scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature29( mot )

scale = false;
thresh1 = 45;
thresh2 = 50;

dataReal = feature_angleSegmentSegment( mot, 'neck', 'root', 'rhip', 'rknee' );

if nargout > 4
    dataBool = feature_AK_bool_femurRightAbductRelSpine_robust(mot);
end