function feature = feature_bool_handLeftLift_robust(mot)

f1 = feature_bool_handLeftLift(mot,1);
f2 = feature_bool_handLeftLift(mot,-0.15);

feature = features_combine_robust(f1,f2);