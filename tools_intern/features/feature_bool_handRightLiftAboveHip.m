function feature = feature_bool_handRightLiftAboveHip(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if right wrist is located above the hip.
%
% Feature value 0: Hand not lifted.
% Feature value 1: Hand lifted.
%
% Parameters:
% spine_offset .... value of 0 corresponds to placement of test plane at root, 
%                   value of 1 corresponds to placement of test plane at belly.

if (nargin<=1)
    spine_offset = 0;
else
    spine_offset = varargin{1};
end

belly_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'root')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'belly')}(:,1)).^2));

feature = feature_distPointNormalPlane(mot,'belly','root','root','rwrist') + spine_offset * belly_length;
feature = (feature >= 0);