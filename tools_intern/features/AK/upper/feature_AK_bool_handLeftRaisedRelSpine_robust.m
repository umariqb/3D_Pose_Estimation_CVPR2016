function feature = feature_AK_bool_handLeftRaisedRelSpine_robust(mot)

f1 = feature_AK_bool_handLeftRaisedRelSpine(mot,0);     % offset==0 means test plane is fixed at neck, offset measured relative to chest_length
f2 = feature_AK_bool_handLeftRaisedRelSpine(mot,-0.2);  % negative offset raises plane above neck

feature = features_combine_robust(f1,f2);