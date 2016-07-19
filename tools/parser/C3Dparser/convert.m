function [skel, mot] = convert(Markers, ParameterGroup, VideoFrameRate, c3dFilename)

numMarkers = size(Markers, 2);
numFrames = size(Markers, 1);
skel = emptySkeleton;
mot = emptyMotion;

mot.njoints = numMarkers;
skel.njoints = mot.njoints;
mot.nframes = numFrames;
mot.frameTime = 1 / VideoFrameRate;
mot.samplingRate = VideoFrameRate;
idx = findstr(c3dFilename, '\');
if isempty(idx)
    mot.filename = c3dFilename;
else
    mot.filename = c3dFilename(idx(end)+1:end);
end
skel.filename = mot.filename;

%% get joint names from ParameterGroup
pointIdx = strmatch('POINT',[ParameterGroup(:).name]);
labelsIdx = strmatch('LABELS', [ParameterGroup( pointIdx ).Parameter(:).name]);
labels = ParameterGroup(pointIdx).Parameter(labelsIdx).data;

%% get scaling factor from ParameterGroup
scaleIdx = strmatch('SCALE', [ParameterGroup( pointIdx ).Parameter(:).name]);
scalingFactor = ParameterGroup(pointIdx).Parameter(scaleIdx).data;

%% get coordinate mappings from ParameterGroup
xScreenIdx = strmatch('X_SCREEN', [ParameterGroup( pointIdx ).Parameter(:).name]);
if (~isempty(xScreenIdx))
    xScreen = ParameterGroup(pointIdx).Parameter(xScreenIdx).data;
else
    xScreen = '+X';
end
    
yScreenIdx = strmatch('Y_SCREEN', [ParameterGroup( pointIdx ).Parameter(:).name]);
if (~isempty(yScreenIdx))
    yScreen = ParameterGroup(pointIdx).Parameter(yScreenIdx).data;
else
    yScreen = '+Z';
end

coordinateMapping = mapCoordinates(xScreen, yScreen);

%% remove joint name group labels (everything before and including ':')
for i = 1:size(labels,2)
    pos = strfind(labels{i}, ':');
    if not(isempty(pos))
        labels{i} = labels{i}(pos+1:length(labels{i}));
    end
end

% map labels to standard vicon-names
labels = mapLabelNamesToVicon(labels, 0);

% copy trajectories for point-cloud animation
for i = 1:size(Markers,2)
    mot.nameMap{i,1} = char(labels(i));
    mot.nameMap{i,2} = 0;
    mot.nameMap{i,3} = i;
end    

for i = 1:size(Markers,2)
    mot.jointTrajectories{i,1}(1,:) = Markers(:, i, coordinateMapping(3)) * (-scalingFactor);
    mot.jointTrajectories{i,1}(2,:) = Markers(:, i, coordinateMapping(2)) * (-scalingFactor);
    mot.jointTrajectories{i,1}(3,:) = Markers(:, i, coordinateMapping(1)) * (-scalingFactor);
end    

skel.paths = buildSkelPathsForPointCloud(skel);
skel.nameMap = mot.nameMap;

mot.boundingBox = computeBoundingBox(mot);
