function feature = feature_bool_footLeftBack_robust(mot)

femur_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'lknee')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lhip')}(:,1)).^2));

f1 = feature_bool_distPointPlane(mot,1,8,6,5,0);
f2 = feature_bool_distPointPlane(mot,1,8,6,5,0.25*femur_length);

feature = features_combine_robust(f1,f2);