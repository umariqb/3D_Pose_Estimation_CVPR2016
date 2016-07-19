function feature = feature_BK_bool_COMAcceX(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature value 0: COM Acceleration X-Direction
% Feature value 1: COM Acceleration X-Direction 
%
% author: Björn Krüger (kruegerb@cs.uni-bonn.de)

feature=BK_calc_dyn_feature(mot,'root_COMAcce_x','doubleTreshold',0,-0.5,0.5);