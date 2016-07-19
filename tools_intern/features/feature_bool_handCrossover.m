function feature = feature_bool_handCrossover(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if wrists are crossed over
%
% Feature value 0: Hands not crossed over.
% Feature value 1: Hands crossed over.
%

d_left = feature_distPointNormalPlane(mot,'lshoulder','rshoulder','lshoulder','lwrist');
d_right = feature_distPointNormalPlane(mot,'lshoulder','rshoulder','lshoulder','rwrist');
feature = ((d_right - d_left) <= 0);
