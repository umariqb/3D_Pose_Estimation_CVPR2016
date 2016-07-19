function feature = feature_bool_footRightLift_robust(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if right foot is located above a plane with normal [0 1 0] located a certain distance below the root.
%
% Feature value 0: Foot not lifted.
% Feature value 1: Foot lifted.
%

f1 = feature_bool_footRightLift(mot);
f2 = feature_bool_footRightLift(mot,1.2);

feature = features_combine_robust(f1,f2);
