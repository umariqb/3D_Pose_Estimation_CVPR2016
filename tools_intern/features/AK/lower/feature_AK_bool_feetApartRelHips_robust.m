function feature = feature_AK_bool_feetApartRelHips_robust(mot)

f1 = feature_AK_bool_feetApartRelHips(mot,1.8);     % threshold for "ankle-apartness" measured relative to humerus_length
f2 = feature_AK_bool_feetApartRelHips(mot,2.1);

feature = features_combine_robust(f1,f2);