function feature = feature_bool_handRightLift_robust(mot)

f1 = feature_bool_handRightLift(mot,1);
f2 = feature_bool_handRightLift(mot,-0.15);

feature = features_combine_robust(f1,f2);