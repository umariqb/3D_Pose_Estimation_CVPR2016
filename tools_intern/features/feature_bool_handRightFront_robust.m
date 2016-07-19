function feature = feature_bool_handRightFront_robust(mot)

f1 = feature_bool_handRightFront(mot,1);
f2 = feature_bool_handRightFront(mot,1.15);

feature = features_combine_robust(f1,f2);