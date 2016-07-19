function feature = feature_bool_footLeftHighVel_robust(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measures absolute velocities of ltoes/lankle 
% Good candidate for floor contacts of rfoot.
%
% Feature value 0: Velocity is low
% Feature value 1: Velocity is high
%

win_len_ms = 100;
femur_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'lhip')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lknee')}(:,1)).^2));

f1 = feature_bool_footLeftHighVel(mot);
f2 = feature_bool_footLeftHighVel(mot,1.25*femur_length);

feature = features_combine_robust(f1,f2);
