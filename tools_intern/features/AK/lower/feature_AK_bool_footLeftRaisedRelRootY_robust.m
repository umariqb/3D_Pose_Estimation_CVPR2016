function feature = feature_AK_bool_footLeftRaisedRelRootY_robust(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if left foot is located above a plane with normal [0 1 0] located a certain distance below the root.
%
% Feature value 0: Foot not lifted.
% Feature value 1: Foot lifted.
%

f1 = feature_AK_bool_footLeftRaisedRelRootY(mot,2.4);
f2 = feature_AK_bool_footLeftRaisedRelRootY(mot,2.1);

feature = features_combine_robust(f1,f2);
