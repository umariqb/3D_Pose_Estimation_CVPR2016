function feature = feature_AK_bool_kneeLeftBent_robust(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measures angle at left knee.
%
% Feature value 0: Knee angle is out of specified range
% Feature value 1: Knee angle is in specified range
%

f1 = feature_AK_bool_kneeLeftBent(mot);
f2 = feature_AK_bool_kneeLeftBent(mot,[0 110]);

feature = features_combine_robust(f1,f2);
