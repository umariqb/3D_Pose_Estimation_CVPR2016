function feature = feature_bool_handLeftRaisedMovingOut(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check whether lfingers are moving away from the body in the direction
% indicated by the neck.
%
% Feature value 0: hand not moving outwards
% Feature value 1: hand moving outwards
%
% Parameters:
% thresh ...... GLOBAL absolute threshold for decision whether a velocity is "greater than zero", 

if (nargin<=1)
    humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'lshoulder')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lelbow')}(:,1)).^2));
    thresh = humerus_length;
else
    thresh = varargin{1};
end

velAvg_lfingers = feature_velPoint(mot,'lfingers','',100);

feature = ones(1,mot.nframes); feature(find(velAvg_lfingers <= thresh)) = 0;

% figure;
% plot(velAvg_lfingers)
% hold
% plot(feature,'black')
% plot(thresh*ones(mot.nframes,1),'red')
