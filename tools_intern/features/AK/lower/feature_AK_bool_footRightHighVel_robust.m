function feature = feature_AK_bool_footRightHighVel_robust(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measures absolute velocities of rtoes/rankle 
% Good candidate for floor contacts of lfoot.
%
% Feature value 0: Velocity is low
% Feature value 1: Velocity is high
%

f1 = feature_AK_bool_footRightHighVel(mot,2);
f2 = feature_AK_bool_footRightHighVel(mot,2.5);

feature = features_combine_robust(f1,f2);
