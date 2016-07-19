function feature = feature_AK_bool_footLeftBackRelLegRight_robust(mot)

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));

f1 = feature_bool_distPointPlane(mot,'root','rankle','rhip','lankle',0);
f2 = feature_bool_distPointPlane(mot,'root','rankle','rhip','lankle',0.375*humerus_length);

feature = features_combine_robust(f1,f2);