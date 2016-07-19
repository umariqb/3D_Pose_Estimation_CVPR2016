function feature = feature_bool_footCrossover_robust(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if feet are crossed over
%
% Feature value 0: Feet not crossed over.
% Feature value 1: Feet crossed over.
%

hip_width = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rhip')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lhip')}(:,1)).^2));

d_left = feature_distPointNormalPlane(mot,'lhip','rhip','lhip','lankle');
d_right = feature_distPointNormalPlane(mot,'lhip','rhip','lhip','rankle');
f1 = ((d_right - d_left) <= 0);
f2 = ((d_right - d_left) <= -0.125*hip_width);

feature = features_combine_robust(f1,f2);
