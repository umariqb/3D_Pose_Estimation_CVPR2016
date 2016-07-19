function feature = feature_AK_bool_feetMoveApart_robust(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature value 0: Feet not moving apart from each other 
% Feature value 1: Feet moving apart from each other at velocity greater than humerus_length*thresh
%

f1 = feature_AK_bool_feetMoveApart(mot,1.3);
f2 = feature_AK_bool_feetMoveApart(mot,1.5);

feature = features_combine_robust(f1,f2);
