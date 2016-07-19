function feature = feature_BK_bool_COMAcceY(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature value 0: COM Acceleration Y-Direction
% Feature value 1: COM Acceleration Y-Direction 
%
% author: Björn Krüger (kruegerb@cs.uni-bonn.de)

feature=BK_calc_dyn_feature(mot,'root_COMAcce_y','doubleTreshold',0,-2,2);