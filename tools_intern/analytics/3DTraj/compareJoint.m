function compareJoint( skel1, mot1, skel2, mot2, jointName )
% compareJoint( skel1, mot1, skel2, mot2, jointName )
%
%       creates a clickable figure showing the l2-distance of the joint
%       given by "jointName".

if nargin < 5
    help compareJoint
    return
end

if length(mot1.jointTrajectories{1}) ~= length(mot2.jointTrajectories{1})
    error('Files have different number of frames and cannot be compared!');
end

idx1 = trajectoryID(mot1, jointName);
idx2 = trajectoryID(mot2, jointName);

diff = mot1.jointTrajectories{idx1} - mot2.jointTrajectories{idx2};
diff = sqrt(dot(diff, diff));

h=figure;
set(h, 'Name', mot1.filename);
plot(diff);
set(gca, 'ButtonDownFcn', {@animateOnClick, skel1, mot1, skel2, mot2});
hold on;
meanDiff = mean(diff);
textXPos = mot1.nframes / 20;

plot(meanDiff * ones(1, length(diff)), ':');
plot( (meanDiff-std(diff)) * ones(1, length(diff)), 'r:');
plot( (meanDiff+std(diff)) * ones(1, length(diff)), 'r:');
text( textXPos, meanDiff, 'mean', 'BackgroundColor',[.9 .9 .9]);
text( textXPos, meanDiff-std(diff), 'mean - std', 'BackgroundColor',[.9 .9 .9]);
t=text( textXPos, meanDiff+std(diff), 'mean + std', 'BackgroundColor',[.9 .9 .9]);

xlabel('frames');
ylabel('deviation');
title(['distance between ' upper(jointName) ' trajectories ( std.dev.=' num2str(std(diff)) ')' ], 'Interpreter', 'none');

axis tight;
xlims = get(gca, 'xlim');
axis auto;
set(gca, 'xlim', xlims);

return;


% -------------------------------------------------------------------------

function animateOnClick(varargin)
skel1 = varargin{3};
mot1 = varargin{4};
skel2 = varargin{5};
mot2 = varargin{6};

t = get(gcf,'selectionType');

% try to find animation window
titleText = 'compareJoint animation figure';
children = get(0, 'Children');
animationWindow = [];
for i=1:length(children)
    if strcmpi( titleText, get(children(i), 'Name') )
        animationWindow = children(i);
    end
end

if isempty(animationWindow)
    h=figure;
    set(h, 'Name', titleText);
else
    set(0, 'CurrentFigure', animationWindow);
end

if strcmpi(t, 'alt')    % right click
    animate(skel2, mot2, 1, 0.5);
elseif strcmpi(t, 'extend') % middle click
    animate([skel1, skel2], [mot1, mot2], 1, 0.5);
else
    animate(skel1, mot1, 1, 0.5);
end
