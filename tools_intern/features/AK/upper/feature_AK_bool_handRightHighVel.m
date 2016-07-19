function feature = feature_AK_bool_handRightHighVel(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measures velocity of rfingers
%
% Feature value 0: Velocity is low
% Feature value 1: Velocity is high
%
% Parameters:
% thresh ...... threshold for decision whether a velocity is "greater than zero", relative to humerus_length

thresh = 1;
if (nargin>1)
    thresh = varargin{1};
end

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1)).^2));

velAvg_lfingers = feature_velPoint(mot,'rfingers','',100);

feature = (velAvg_lfingers >= thresh*humerus_length);