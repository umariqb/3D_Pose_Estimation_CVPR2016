function [ scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature27( mot )

scale = false;
thresh1 = 155;
thresh2 = 150;

dataReal = feature_angleSegmentSegment( mot, 'neck', 'root', 'relbow', 'rshoulder' );

if nargout > 4
    dataBool = feature_AK_bool_humerusRightAbductRelSpine_robust(mot);
end