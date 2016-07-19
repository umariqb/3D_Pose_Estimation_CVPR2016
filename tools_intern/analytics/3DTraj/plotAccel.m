function plotAccel( mot )
% plotAccel( mot )

if nargin < 1
    help plotAccel
    return
end

traj = mot.jointTrajectories;

nFrames = length(traj{1});
nJoints = length(traj);
m = floor(sqrt(nJoints));

if m*m ~= nJoints
    m = m + 1;
end

n = floor(nJoints/m);

if mod(nJoints,m)~=0
    n = n + 1;
end

figure;
for i = 1:nJoints
    accel = traj{i}(:,2:nFrames) - traj{i}(:,1:nFrames-1);
    accel = sqrt(dot(accel, accel));
    
    % plot graphs
	SUBPLOT(m,n,i);
	plot(accel);
end
