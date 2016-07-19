function feature = feature_bool_handRightHighVel(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measures absolute velocities of rfingers 
%
% Feature value 0: Velocity is low
% Feature value 1: Velocity is high
%
% Parameters:
% thresh ...... GLOBAL absolute threshold for decision whether a velocity is "greater than zero", 

if (nargin<=1)
    humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1)).^2));
    thresh = humerus_length;
else
    thresh = varargin{1};
end

velAvg_rfingers = feature_velPoint(mot,'rfingers','',100);

feature = ones(1,mot.nframes); feature(find(velAvg_rfingers <= thresh)) = 0;

% figure;
% plot(velAvg_rfingers)
% hold
% plot(feature,'black')
% plot(thresh*ones(mot.nframes,1),'red')
