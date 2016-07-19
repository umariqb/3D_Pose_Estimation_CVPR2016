function feature = feature_AK_bool_footLeftHighVel_robust(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measures absolute velocities of ltoes/lankle 
% Good candidate for floor contacts of rfoot.
%
% Feature value 0: Velocity is low
% Feature value 1: Velocity is high
%

f1 = feature_AK_bool_footLeftHighVel(mot,2);
f2 = feature_AK_bool_footLeftHighVel(mot,2.5);

feature = features_combine_robust(f1,f2);
