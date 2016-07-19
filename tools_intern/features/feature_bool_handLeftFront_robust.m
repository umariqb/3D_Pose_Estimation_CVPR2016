function feature = feature_bool_handLeftFront_robust(mot)

f1 = feature_bool_handLeftFront(mot,1);
f2 = feature_bool_handLeftFront(mot,1.15);

feature = features_combine_robust(f1,f2);