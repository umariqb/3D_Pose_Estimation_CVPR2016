function feature = feature_AK_bool_rootBehindFeetLeftRightNeck_robust(mot)

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));

dist = feature_distPointPlane(mot,'lankle','neck','rankle','root');

thresh1 = -0.35;
thresh2 = -0.5;

feature = features_combine_robust(dist<thresh1*humerus_length,dist<thresh2*humerus_length);
