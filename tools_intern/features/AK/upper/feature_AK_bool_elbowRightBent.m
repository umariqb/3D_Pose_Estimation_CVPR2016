function feature = feature_AK_bool_elbowRightBent(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measures angle at right elbow.
%
% Feature value 0: Elbow angle is out of specified range
% Feature value 1: Elbow angle is in specified range
%
% Parameters:
% range ... 2-vector containing lower and upper bounds of the "1" interval (in degrees).
%           Default is [0 120], corresponding to a bent elbow 
%
if (nargin<=1)
    range = [0 120];
else
    range = varargin{1};
end

feature = feature_angleJoint(mot,'rshoulder','rwrist','relbow');
feature = (feature >= range(1)) & (feature <= range(2));