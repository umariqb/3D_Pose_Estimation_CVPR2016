function feature = feature_AK_bool_footLeftSidewaysRelHips_robust(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if left foot is located to the left of a test plane orthogonal to the lhip-rhip line
%
% Feature value 0: Foot not sideways.
% Feature value 1: Foot sideways.

f1 = feature_AK_bool_footLeftSidewaysRelHips(mot);
f2 = feature_AK_bool_footLeftSidewaysRelHips(mot,-1.2);

feature = features_combine_robust(f1,f2);
