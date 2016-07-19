function feature = feature_bool_elbowLeftAngle_robust(mot)

f1 = feature_bool_elbowLeftAngle(mot);
f2 = feature_bool_elbowLeftAngle(mot,[0 110]);

feature = features_combine_robust(f1,f2);