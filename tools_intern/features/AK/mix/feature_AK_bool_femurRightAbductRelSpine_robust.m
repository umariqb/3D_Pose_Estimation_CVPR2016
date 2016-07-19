function feature = feature_AK_bool_femurRightAbductRelSpine_robust(mot)

f = feature_angleSegmentSegment( mot, 'neck', 'root', 'rhip', 'rknee' );

thresh1 = 45;
thresh2 = 50;

feature = features_combine_robust(f>thresh1,f>thresh2);