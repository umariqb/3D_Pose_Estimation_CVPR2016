function feature = feature_AK_real_footRightHighVel(mot,varargin)
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

femur_length = 1/2*(sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'lhip')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lknee')}(:,1)).^2))...
	                       + sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rhip')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rknee')}(:,1)).^2)));


feature = 1/2 * (velAvg_rtoes + velAvg_rankle)./femur_length;

% feature = 1/2 * (velAvg_rtoes + velAvg_rankle)./humerus_length;
% feature = and(velAvg_rtoes >= humerus_length*thresh, velAvg_rankle >= humerus_length*thresh);
