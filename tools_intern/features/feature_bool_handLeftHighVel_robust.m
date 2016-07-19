function feature = feature_bool_handLeftHighVel_robust(mot)

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'lshoulder')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lelbow')}(:,1)).^2));

f1 = feature_bool_handLeftHighVel(mot);
f2 = feature_bool_handLeftHighVel(mot,1.25*humerus_length);

feature = features_combine_robust(f1,f2);