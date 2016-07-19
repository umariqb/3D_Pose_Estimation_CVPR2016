function feature = feature_bool_kneeRightAngle_robust(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measures angle at right knee.
%
% Feature value 0: Knee angle is out of specified range
% Feature value 1: Knee angle is in specified range
%

f1 = feature_bool_kneeRightAngle(mot);
f2 = feature_bool_kneeRightAngle(mot,[0 110]);

feature = features_combine_robust(f1,f2);
