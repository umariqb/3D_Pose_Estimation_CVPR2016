function feature = feature_AK_bool_handsMoveApart_robust(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature value 0: Hands not moving apart from each other 
% Feature value 1: Hands moving apart from each other at velocity greater than humerus_length*thresh
%

f1 = feature_AK_bool_handsMoveApart(mot,1.2);
f2 = feature_AK_bool_handsMoveApart(mot,1.4);

feature = features_combine_robust(f1,f2);
