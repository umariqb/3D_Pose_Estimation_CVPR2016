function feature = feature_AK_bool_footRightHighVel(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measures absolute velocities of rtoes/rankle 
% Good candidate for floor contacts of lfoot.
%
% Feature value 0: Velocity is low
% Feature value 1: Velocity is high
%
% Parameters:
% thresh ...... GLOBAL absolute threshold for decision whether a velocity is "greater than zero", 

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));
thresh = 1.5;
if (nargin>1)
    thresh = varargin{1};
end

velAvg_rtoes = feature_velPoint(mot,'rtoes','',100);
velAvg_rankle = feature_velPoint(mot,'rankle','',100);

feature = and(velAvg_rtoes >= humerus_length*thresh, velAvg_rankle >= humerus_length*thresh);