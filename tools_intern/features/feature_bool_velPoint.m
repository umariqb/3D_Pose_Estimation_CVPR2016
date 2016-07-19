function feature = feature_bool_velPoint(mot,p_name,p_rel_name,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measures velocities of a body point p relative to some body point p_rel
%
% Feature value 0: Velocity is low
% Feature value 1: Velocity is high
%
% Parameters:
% thresh ...... relative threshold for decision whether a velocity is "greater than zero", relative to humerus_length

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'lshoulder')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lelbow')}(:,1)).^2));
thresh = 1;
win_len_ms = ceil(mot.samplingRate/10);

if (nargin>4)    
    thresh = varargin{2}*humerus_length;
end
if (nargin>3)
    win_len_ms = varargin{1};
end

velAvgRel = feature_velPoint(mot,p_name,p_rel_name,win_len_ms);

feature = logical(ones(1,mot.nframes)); 
feature(find(velAvgRel <= thresh)) = 0;

% figure;
% plot(velAvgRel)
% hold
% plot(feature,'black')
% plot(thresh*ones(mot.nframes,1),'red')
