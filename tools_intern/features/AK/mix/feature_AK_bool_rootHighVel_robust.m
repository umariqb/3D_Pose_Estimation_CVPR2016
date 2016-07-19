function feature = feature_AK_bool_rootHighVel_robust(mot)

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));

velRoot = feature_velPoint(mot,'root');

thresh1 = 2.0;
thresh2 = 2.3;

f1 = velRoot >= thresh1*humerus_length;
f2 = velRoot >= thresh2*humerus_length;

feature = features_combine_robust(f1,f2);
