function feature = feature_AK_bool_feetApartRelHips(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if the projections of the ankles onto the hip line are far apart from each other
%
% Feature value 0: Ankles apart.
% Feature value 1: Ankles not apart.
%
% Parameters:
% thresh: Distance measured relative to humerus_length for decision whether ankles are apart. Default: 2
%

thresh = 1.8;
if (nargin>1)
    thresh = varargin{1};
end

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));

feature = feature_distPointNormalPlane(mot,'lhip','rhip','lankle','rankle');
feature = (abs(feature) >= thresh*humerus_length);