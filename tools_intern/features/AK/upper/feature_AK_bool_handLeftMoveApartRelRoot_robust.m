function feature = feature_AK_bool_handLeftMoveApartRelRoot_robust(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature value 0: Hand not moving away from root
% Feature value 1: Hand moving away from root at velocity greater than humerus_length*thresh
%

f1 = feature_AK_bool_handLeftMoveApartRelRoot(mot,1.2);
f2 = feature_AK_bool_handLeftMoveApartRelRoot(mot,1.4);

feature = features_combine_robust(f1,f2);
