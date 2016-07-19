function feature = feature_bool_handTouch_robust(mot)

f1 = feature_bool_handTouch(mot);
f2 = feature_bool_handTouch(mot,0.75);

feature = features_combine_robust(f1,f2);