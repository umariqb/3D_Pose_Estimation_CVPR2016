function [velRel,dist] = feature_velRelPointNormalPlane(mot,p1_name,p2_name,p3_name,q_name,varargin)
% function [velRel,dist] = feature_velRelPointNormalPlane(mot,p1_name,p2_name,p3_name,q_name,varargin)
%
% p1 and p2 define a normal vector n pointing towards p2
% p3 is the fixture point for the plane defined by n
%
% NOTES: - Last velocity value is duplicated to maintain the length of the input sequence.
%        - Choosing win_len_ms<=1000/samplingRate amounts to no averaging at all.

if (ischar(p1_name))
    p1 = trajectoryID(mot,p1_name);
else
    p1 = mot.nameMap{p1_name,3};
end
if (ischar(p2_name))
    p2 = trajectoryID(mot,p2_name);
else
    p2 = mot.nameMap{p2_name,3};
end
if (ischar(p3_name))
    p3 = trajectoryID(mot,p3_name);
else
    p3 = mot.nameMap{p3_name,3};
end
if (ischar(q_name))
    q = trajectoryID(mot,q_name);
else
    q = mot.nameMap{q_name,3};
end

win_len_ms = 0;
if (nargin>5)
    win_len_ms = varargin{1};
end

win_len = ceil(win_len_ms/1000*mot.samplingRate);

if (win_len < 1)
    win_len = 1;
end

n = mot.jointTrajectories{p2} - mot.jointTrajectories{p1};
n = n./repmat(sqrt(sum(n.^2)),3,1);

vel = diff((mot.jointTrajectories{q}-mot.jointTrajectories{p3})'); % relative speed between point q and plane fixture
vel = vel';
vel = [vel vel(:,end)];

if (mot.nframes < win_len)
    vel = padarray(vel,[0 win_len - mot.nframes],'symmetric','post');
end

velAvg = padarray(vel,[0 ceil(win_len/2)],'symmetric','both');
velAvg_conv = zeros(3,size(velAvg,2)+win_len-1);
for k=1:3
    velAvg_conv(k,:) = conv(velAvg(k,:),(1/win_len)*ones(win_len,1));
end

velAvg = velAvg_conv(:,win_len+1:win_len+mot.nframes) * mot.samplingRate;

velRel = dot(n,velAvg);
dist = dot(n,mot.jointTrajectories{q}-mot.jointTrajectories{p3});

%% alternative mode of computation: smoothed derivative of distance function
%% difference between the two approaches: here, the normal vector is implicitly smoothed
%% together with the 3D trajectory, in the other approach it is left unchanged
% vel = diff(dist);
% vel = [vel vel(end)];
% if (mot.nframes < win_len)
%     vel = padarray(vel,[0 win_len - mot.nframes],'symmetric','post');
% end
% 
% velAvg = padarray(vel,[0 ceil(win_len/2)],'symmetric','both');
% velAvg_conv = conv(velAvg,(1/win_len)*ones(win_len,1));
% velAvg = velAvg_conv(win_len+1:win_len+mot.nframes) * mot.samplingRate;
% velRel = velAvg;