function [ scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature28( mot )

scale = false;
thresh1 = 155;
thresh2 = 150;

dataReal = feature_angleSegmentSegment( mot, 'neck', 'root', 'lelbow', 'lshoulder' );

if nargout > 4
    dataBool = feature_AK_bool_humerusLeftAbductRelSpine_robust(mot);
end