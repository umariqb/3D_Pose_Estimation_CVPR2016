function feature = feature_AK_bool_handsMoveTogether_robust(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature value 0: Hands not approaching each other 
% Feature value 1: Hands approaching each other at velocity greater than humerus_length*thresh
%

f1 = feature_AK_bool_handsMoveTogether(mot,1.2);
f2 = feature_AK_bool_handsMoveTogether(mot,1.4);

feature = features_combine_robust(f1,f2);
