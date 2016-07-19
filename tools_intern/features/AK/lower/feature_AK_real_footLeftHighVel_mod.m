function feature = feature_AK_real_footLeftHighVel(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measures absolute velocities of ltoes/lankle 
% Good candidate for floor contacts of lfoot.
%
% Feature value 0: Velocity is low
% Feature value 1: Velocity is high
%
% Parameters:
% thresh ...... threshold for decision whether a velocity is "greater than zero", relative to humerus_length

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));
thresh = 1.5;
if (nargin>1)
    thresh = varargin{1};
end

velAvg_ltoes = feature_velPoint(mot,'ltoes','',100);
velAvg_lankle = feature_velPoint(mot,'lankle','',100);

femur_length = 1/2*(sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'lhip')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lknee')}(:,1)).^2))...
	                       + sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rhip')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rknee')}(:,1)).^2)));

feature = 1/2 * (velAvg_ltoes + velAvg_lankle)./femur_length;
% feature = 1/2 * (velAvg_ltoes + velAvg_lankle)./humerus_length;
% feature = and(velAvg_ltoes >= humerus_length*thresh, velAvg_lankle >= humerus_length*thresh);

% Anpassung an [0, 180]
feature = feature*180/24;