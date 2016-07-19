function feature = feature_BK_bool_rfoot_force(mot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature value 0: if kinetic Energy is smaller then treshold
% Feature value 1: otherwise
%
% author: Björn Krüger (kruegerb@cs.uni-bonn.de)

global VARS_GLOBAL;
treshold=VARS_GLOBAL.treshold;
feature=BK_calc_dyn_feature(mot,'rfoot_ForceAbs','singleTresholdAdaptive',treshold);