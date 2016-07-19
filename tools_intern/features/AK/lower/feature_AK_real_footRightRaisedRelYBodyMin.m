function feature = feature_AK_real_footRightRaisedRelYBodyMin(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if right foot is located above a plane with normal [0 1 0] located a certain distance above the Y minimum of the body.
%
% Feature value 0: Foot not lifted.
% Feature value 1: Foot lifted.
%
% Parameters:
% height .... value of 0 corresponds to placement of test plane at body_min level, 
%             value of 1 corresponds to placement of test plane humerus_length above body_min level.

if (nargin<=1)
    height = 1;
else
    height = varargin{1};
end

% humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));
femur_length = 1/2*(sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'lhip')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lknee')}(:,1)).^2))...
	                       + sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rhip')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rknee')}(:,1)).^2)));

minY = feature_YBodyMin(mot);

feature = mot.jointTrajectories{trajectoryID(mot,'rtoes')}(2,:) - minY - height*femur_length;

% feature = mot.jointTrajectories{trajectoryID(mot,'rtoes')}(2,:) - minY - height*humerus_length;

% feature = (feature >= 0); % only look at y component
