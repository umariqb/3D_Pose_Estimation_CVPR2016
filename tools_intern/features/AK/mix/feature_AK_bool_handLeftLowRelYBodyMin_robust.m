function feature = feature_AK_bool_handLeftLowRelYBodyMin_robust(mot)

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));

YBodyMin = feature_YBodyMin(mot,{'lfingers','lwrist'});
YHand = mot.jointTrajectories{trajectoryID(mot,'lfingers')}(2,:);

thresh1 = 1.4;
thresh2 = 1.2;

f1 = YHand < YBodyMin + thresh1*humerus_length;
f2 = YHand < YBodyMin + thresh2*humerus_length;

feature = features_combine_robust(f1,f2);