function feature = feature_AK_bool_feetMoveApartRelHips(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature value 0: ankles not moving apart from each other, using projection of relative velocity of ankles onto hip line 
% Feature value 1: ankles moving apart each other at velocity greater than humerus_length*thresh
%
% Parameters:
% thresh ...... threshold for decision whether a velocity is "greater than zero", relative to humerus_length

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));
thresh = 1.5;
if (nargin>1)
    thresh = varargin{1};
end

featureL = feature_velRelPointNormalPlane(mot,'lhip','rhip','rhip','lankle',100);
featureR = feature_velRelPointNormalPlane(mot,'lhip','rhip','rhip','rankle',100);
feature = (featureR-featureL) >= humerus_length*thresh;
