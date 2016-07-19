function feature = feature_bool_kneeLeftAngle(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measures angle at left knee.
%
% Feature value 0: Knee angle is out of specified range
% Feature value 1: Knee angle is in specified range
%
% Parameters:
% range ... 2-vector containing lower and upper bounds of the "1" interval (in degrees).
%           Default is [0 120], corresponding to a bent knee 
%
if (nargin<=1)
    range = [0 120];
else
    range = varargin{1};
end

feature = feature_angleJoint(mot,'lhip','lankle','lknee');
feature = (feature >= range(1)) & (feature <= range(2));