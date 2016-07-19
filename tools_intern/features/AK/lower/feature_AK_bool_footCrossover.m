function feature = feature_AK_bool_footCrossover(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if feet are crossed over
%
% Feature value 0: Feet not crossed over.
% Feature value 1: Feet crossed over.
%

d_left = feature_distPointNormalPlane(mot,'lhip','rhip','lhip','lankle');
d_right = feature_distPointNormalPlane(mot,'lhip','rhip','lhip','rankle');
feature = ((d_right - d_left) <= 0);
