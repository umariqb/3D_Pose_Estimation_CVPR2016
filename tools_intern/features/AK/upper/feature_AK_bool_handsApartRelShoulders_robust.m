function feature = feature_AK_bool_handsApartRelShoulders_robust(mot)

f1 = feature_AK_bool_handsApartRelShoulders(mot,2);     % threshold for "wrist-apartness" measured relative to shoulder_width
f2 = feature_AK_bool_handsApartRelShoulders(mot,2.5);

feature = features_combine_robust(f1,f2);