function feature = feature_bool_footRightSideways_robust(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if right foot is located to the right of a test plane orthogonal to the lhip-rhip line
%
% Feature value 0: Foot not sideways.
% Feature value 1: Foot sideways.

f1 = feature_bool_footRightSideways(mot);
f2 = feature_bool_footRightSideways(mot,-1.2);

feature = features_combine_robust(f1,f2);
