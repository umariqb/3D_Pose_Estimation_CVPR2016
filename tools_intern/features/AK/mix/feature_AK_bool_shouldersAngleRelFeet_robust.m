function feature = feature_AK_bool_shouldersAngleRelFeet_robust(mot)

angle = feature_angleSegmentSegment(mot,'lshoulder','rshoulder','lankle','rankle');

thresh1 = [35, 180-35];
thresh2 = [45, 180-45];

f1 = angle >= thresh1(1) & angle <= thresh1(2);
f2 = angle >= thresh2(1) & angle <= thresh2(2);

feature = features_combine_robust(f1,f2);