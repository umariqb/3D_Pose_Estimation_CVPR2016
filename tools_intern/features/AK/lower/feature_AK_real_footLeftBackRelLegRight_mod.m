function feature = feature_AK_real_footLeftBackRelLegRight(mot)

% humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));

f1 = feature_real_distPointPlane(mot,'root','rankle','rhip','lankle',0);

feature = f1;

% Anpassung an [0, 180]
feature = (feature+40)*180/79;