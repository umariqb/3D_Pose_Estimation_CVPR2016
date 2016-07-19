function figureHandle = compareJointMarkers( mot1, jointName, mot2, markerNames, showTitle, showLegend)
% figureHandle = compareJointMarkers( mot1, jointName, mot2, markerNames, showTitle, showLegend)
%
%       Displays distances between joint "jointName" of "mot1" and markers
%       given by "markerNames" of mot2.

if nargin < 5
    showTitle = true;
end

if nargin < 6
    showLegend = true;
end

if ~iscell(markerNames)
    markerNames{1} = markerNames;
end

n = length(markerNames);
jointTraj = mot1.jointTrajectories{trajectoryID(mot1, jointName)};

for i=1:n
    idx = trajectoryID(mot2, markerNames{i});
    markerTraj = mot2.jointTrajectories{idx};

    dist(i,:) = sqrt(dot(jointTraj - markerTraj, jointTraj - markerTraj));
    
end


figureHandle = figure;

hold on;
colors = {'b', 'r', 'g', 'm', 'k', 'c'};
for i=1:n
    plot( dist(i,:), colors{i} );
end

axis tight;
axis(axis + [0 0 0 1]);

if showLegend
    legend(markerNames);
end

if showTitle
    title(['distance between joint "' jointName '" and markers']);
end