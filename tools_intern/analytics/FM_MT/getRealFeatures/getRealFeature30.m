function [ scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature30( mot )

scale = false;
thresh1 = 45;
thresh2 = 50;

dataReal = feature_angleSegmentSegment( mot, 'neck', 'root', 'lhip', 'lknee' );

if nargout > 4
    dataBool = feature_AK_bool_femurLeftAbductRelSpine_robust(mot);
end