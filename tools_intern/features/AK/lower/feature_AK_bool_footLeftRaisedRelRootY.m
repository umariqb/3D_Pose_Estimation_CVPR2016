function feature = feature_AK_bool_footLeftRaisedRelRootY(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if left foot is located above a plane with normal [0 1 0] located a certain distance below the root.
%
% Feature value 0: Foot not lifted.
% Feature value 1: Foot lifted.
%
% Parameters:
% root_offset .... value of 0 corresponds to placement of test plane at root, 
%                  value of 1 corresponds to placement of test plane humerus_length below root.

if (nargin<=1)
    root_offset = 2.1;
else
    root_offset = varargin{1};
end

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));

% n = repmat([0;1;0],1,mot.nframes);
% feature = dot(n,mot.jointTrajectories{trajectoryID(mot,'ltoes')}-mot.jointTrajectories{trajectoryID(mot,'root')}) + root_offset*humerus_length;
feature = mot.jointTrajectories{trajectoryID(mot,'ltoes')}-mot.jointTrajectories{trajectoryID(mot,'root')} + root_offset*humerus_length;

feature = (feature(2,:) >= 0); % only look at y component