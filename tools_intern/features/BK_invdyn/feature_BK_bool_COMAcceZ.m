function feature = feature_BK_bool_COMAcceZ(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature value 0: COM Acceleration Z-Direction
% Feature value 1: COM Acceleration Z-Direction 
%
% author: Björn Krüger (kruegerb@cs.uni-bonn.de)

feature=BK_calc_dyn_feature(mot,'root_COMAcce_z','doubleTreshold',0,-0.5,0.5);