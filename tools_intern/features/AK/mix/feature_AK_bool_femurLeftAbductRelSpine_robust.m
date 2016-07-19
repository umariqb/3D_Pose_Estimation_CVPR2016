function feature = feature_AK_bool_femurLeftAbductRelSpine_robust(mot)

f = feature_angleSegmentSegment( mot, 'neck', 'root', 'lhip', 'lknee' );

thresh1 = 45;
thresh2 = 50;

feature = features_combine_robust(f>thresh1,f>thresh2);