function feature = feature_bool_footRightHighVel_robust(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measures absolute velocities of rtoes/rankle 
% Good candidate for floor contacts of lfoot.
%
% Feature value 0: Velocity is low
% Feature value 1: Velocity is high
%

win_len_ms = 100;
femur_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rhip')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rknee')}(:,1)).^2));

f1 = feature_bool_footRightHighVel(mot);
f2 = feature_bool_footRightHighVel(mot,1.25*femur_length);

feature = features_combine_robust(f1,f2);
