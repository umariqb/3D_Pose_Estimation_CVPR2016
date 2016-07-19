function feature = feature_AK_real_footLeftBackRelLegRight(mot)

% humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));

femur_length = 1/2*(sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'lhip')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lknee')}(:,1)).^2))...
	                       + sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rhip')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rknee')}(:,1)).^2)));

f1 = feature_real_distPointPlane(mot,'root','rankle','rhip','lankle',0);
% f2 = feature_bool_distPointPlane(mot,'root','rankle','rhip','lankle',0.375*humerus_length);

% feature = features_combine_robust(f1,f2);
feature = f1 ./ femur_length;
