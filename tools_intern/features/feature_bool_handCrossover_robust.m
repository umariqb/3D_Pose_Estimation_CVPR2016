function feature = feature_bool_handCrossover_robust(mot)

shoulder_width = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lshoulder')}(:,1)).^2));

d_left = feature_distPointNormalPlane(mot,'lshoulder','rshoulder','lshoulder','lwrist');
d_right = feature_distPointNormalPlane(mot,'lshoulder','rshoulder','lshoulder','rwrist');

f1 = ((d_right - d_left) <= 0);
f2 = ((d_right - d_left) <= -0.125*shoulder_width);

feature = features_combine_robust(f1,f2);