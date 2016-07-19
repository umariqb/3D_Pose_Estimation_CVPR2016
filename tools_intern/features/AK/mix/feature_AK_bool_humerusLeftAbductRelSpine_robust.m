function feature = feature_AK_bool_humerusLeftAbductRelSpine_robust(mot)

f = feature_angleSegmentSegment( mot, 'neck', 'root', 'lelbow', 'lshoulder' );

thresh1 = 155;
thresh2 = 150;

feature = features_combine_robust(f<thresh1,f<thresh2);