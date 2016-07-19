function feature = feature_bool_footLeftHighVel(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measures absolute velocities of ltoes/lankle 
% Good candidate for floor contacts of lfoot.
%
% Feature value 0: Velocity is low
% Feature value 1: Velocity is high
%
% Parameters:
% thresh ...... GLOBAL absolute threshold for decision whether a velocity is "greater than zero", 

win_len_ms = 100;
femur_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'lhip')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lknee')}(:,1)).^2));
thresh = femur_length;
if (nargin>3)
    thresh = varargin{2};
end
if (nargin>2)
    win_len_ms = varargin{1};
end

velAvg_ltoes = feature_velPoint(mot,'ltoes','',win_len_ms);
velAvg_lankle = feature_velPoint(mot,'lankle','',win_len_ms);

z = zeros(1,mot.nframes);
x11 = z; x11(find(velAvg_ltoes <= thresh)) = 1;
x12 = z; x12(find(velAvg_lankle <= thresh)) = 1;

feature = or(x11,x12);
feature = not(feature);


% figure;
% plot(velAvg_ltoes)
% hold
% plot(velAvg_lankle,'red')
% plot(feature,'black')
% plot(thresh*ones(mot.nframes,1))