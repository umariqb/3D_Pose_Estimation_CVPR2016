function feature = feature_bool_footLeftSideways(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if left foot is located to the left of a test plane orthogonal to the lhip-rhip line
%
% Feature value 0: Foot not sideways.
% Feature value 1: Foot sideways.
%
% Parameters:
% hip_offset .... default value of -1 corresponds to placement of test plane at one hip width left of lhip

if (nargin<=1)
    hip_offset = -1;
else
    hip_offset = varargin{1};
end

hip_width = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'lhip')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rhip')}(:,1)).^2));

feature = feature_distPointNormalPlane(mot,'rhip','lhip','lhip','lankle') + hip_offset * hip_width;
feature = (feature >= 0);