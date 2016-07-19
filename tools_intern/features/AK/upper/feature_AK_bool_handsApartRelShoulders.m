function feature = feature_AK_bool_handsApartRelShoulders(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if the projections of the wrists onto the shoulder line are far apart from each other
%
% Feature value 0: Wrists apart.
% Feature value 1: Wrists not apart.
%
% Parameters:
% thresh: Distance measured relative to shoulder_width for decision whether wrists are apart. Default: 3
%

thresh = 3;
if (nargin>1)
    thresh = varargin{1};
end

shoulder_width = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lshoulder')}(:,1)).^2));

feature = feature_distPointNormalPlane(mot,'lshoulder','rshoulder','lwrist','rwrist');
feature = (abs(feature) >= thresh*shoulder_width);