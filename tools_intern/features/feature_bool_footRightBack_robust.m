function feature = feature_bool_footRightBack_robust(mot)

femur_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rknee')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rhip')}(:,1)).^2));

f1 = feature_bool_distPointPlane(mot,1,2,4,9,0);
f2 = feature_bool_distPointPlane(mot,1,2,4,9,0.25*femur_length);

feature = features_combine_robust(f1,f2);