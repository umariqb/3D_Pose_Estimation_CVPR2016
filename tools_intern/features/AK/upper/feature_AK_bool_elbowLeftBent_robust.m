function feature = feature_AK_bool_elbowLeftBent_robust(mot)

f1 = feature_AK_bool_elbowLeftBent(mot,[0 120]);
f2 = feature_AK_bool_elbowLeftBent(mot,[0 110]);

feature = features_combine_robust(f1,f2);