function feature = feature_bool_handRightHighVel_robust(mot)

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1)).^2));

f1 = feature_bool_handRightHighVel(mot);
f2 = feature_bool_handRightHighVel(mot,1.25*humerus_length);

feature = features_combine_robust(f1,f2);