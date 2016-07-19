function feature = feature_AK_bool_feetMoveTogetherRelHips_robust(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature value 0: ankles not approaching each other, using projection of relative velocity of ankles onto hip line 
% Feature value 1: ankles approaching each other at velocity greater than humerus_length*thresh
%

f1 = feature_AK_bool_feetMoveTogetherRelHips(mot,1.3);
f2 = feature_AK_bool_feetMoveTogetherRelHips(mot,1.5);

feature = features_combine_robust(f1,f2);
