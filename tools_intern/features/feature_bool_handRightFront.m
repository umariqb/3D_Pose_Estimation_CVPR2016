function feature = feature_bool_handRightFront(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if right wrist is located in front of the body.
%
% Feature value 0: Hand not in front.
% Feature value 1: Hand in front.
%
% Parameters:
% front_offset .... value of 0 corresponds to placement of test plane at root, 
%                   value of 1 corresponds to placement of test plane in a distance of humerus_length in front of the body.

if (nargin<=1)
    front_offset = 1;
else
    front_offset = varargin{1};
end

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1)).^2));

feature = (feature_distPointPlane(mot,'root','lshoulder','rshoulder','rwrist') - front_offset * humerus_length) >= 0;
