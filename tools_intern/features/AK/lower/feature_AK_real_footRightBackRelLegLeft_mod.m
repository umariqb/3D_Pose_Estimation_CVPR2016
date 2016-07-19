function feature = feature_AK_real_footRightBackRelLegLeft(mot)

% humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));

f1 = feature_real_distPointPlane(mot,'root','lhip','lankle','rankle',0);
% f2 = feature_bool_distPointPlane(mot,'root','lhip','lankle','rankle',0.375*humerus_length);

% feature = features_combine_robust(f1,f2);
feature = f1;

% Anpassung an [0, 180]
feature = (feature+40)*180/79;