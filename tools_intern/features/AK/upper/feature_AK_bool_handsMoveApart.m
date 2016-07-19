function feature = feature_AK_bool_handsMoveApart(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature value 0: wrists not moving apart from each other 
% Feature value 1: wrists moving apart from each other at velocity greater than humerus_length*thresh
%
% Parameters:
% thresh ...... threshold for decision whether a velocity is "greater than zero", relative to humerus_length

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));
thresh = 1.5;
if (nargin>1)
    thresh = varargin{1};
end

feature = feature_velRelPointNormalPlane(mot,'rwrist','lwrist','rwrist','lwrist',100);
feature = feature >= humerus_length*thresh;
