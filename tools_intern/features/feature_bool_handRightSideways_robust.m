function feature = feature_bool_handRightSideways_robust(mot)

f1 = feature_bool_handRightSideways(mot,-0.4);
f2 = feature_bool_handRightSideways(mot,-0.5);

feature = features_combine_robust(f1,f2);