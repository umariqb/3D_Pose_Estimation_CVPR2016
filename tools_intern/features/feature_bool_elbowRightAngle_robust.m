function feature = feature_bool_elbowRightAngle_robust(mot)

f1 = feature_bool_elbowRightAngle(mot);
f2 = feature_bool_elbowRightAngle(mot,[0 110]);

feature = features_combine_robust(f1,f2);