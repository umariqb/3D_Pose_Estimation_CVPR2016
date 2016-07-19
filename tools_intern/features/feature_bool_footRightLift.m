function feature = feature_bool_footRightLift(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if right foot is located above a plane with normal [0 1 0] located a certain distance below the root.
%
% Feature value 0: Foot not lifted.
% Feature value 1: Foot lifted.
%
% Parameters:
% root_offset .... value of 0 corresponds to placement of test plane at root, 
%                  value of 1 corresponds to placement of test plane femur_length below root.

if (nargin<=1)
    root_offset = 1.4;
else
    root_offset = varargin{1};
end

femur_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rknee')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rhip')}(:,1)).^2));

%p1 = 0.5*(mot.jointTrajectories{trajectoryID(mot,'lhip')}+mot.jointTrajectories{trajectoryID(mot,'rhip')});
%n = mot.jointTrajectories{trajectoryID(mot,'root')} - p1;
%n = n./repmat(sqrt(sum(n.^2)),3,1);
n = repmat([0;1;0],1,mot.nframes);
feature = dot(n,mot.jointTrajectories{trajectoryID(mot,'rtoes')}-mot.jointTrajectories{trajectoryID(mot,'root')}) + root_offset*femur_length;

feature = (feature >= 0);