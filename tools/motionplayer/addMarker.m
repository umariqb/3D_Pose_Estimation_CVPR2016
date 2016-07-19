function addMarker(marker)
global SCENE

numMarkers = SCENE.status.numMarkers + 1;
SCENE.status.numMarkers = numMarkers;

stream = marker.stream;
color = marker.color;
d = marker.size;
nframes = size(stream,2);
if(isfield(marker,'faceAlphaStream'))
    if(size(marker.faceAlphaStream,1) == 1)
        faceAlphaStream = repmat(marker.faceAlphaStream(1),nframes,1);
    elseif (size(marker.faceAlphaStream,1) == nframes)
        faceAlphaStream = marker.faceAlphaStream;
    else
        s = strcat('Dimensions of marker.stream(',num2str(nframes),...
            ') and marker.faceAlphaStream(',...
            num2str(size(marker.faceAlphaStream,1)),...
            ') do not match! Using alphaStream = 1 instead.');
        disp(['WARNING: ' s]);
        faceAlphaStream = ones(nframes,1);
    end
else
    faceAlphaStream = ones(nframes,1);
end

if(isfield(marker,'colorStream'))
    if(size(marker.colorStream,1) == 1)
        colorStream = repmat(marker.colorStream(1),nframes,1);
    elseif (size(marker.colorStream,1) == nframes)
        colorStream = marker.colorStream;
    else
        s = strcat('Dimensions of marker.stream(',num2str(nframes),...
            ') and marker.faceAlphaStream(',...
            num2str(size(marker.colorStream,1)),...
            ') do not match! Using colorStream = input-color instead.');
        disp(['WARNING: ' s]);
        colorStream = repmat(color,nframes,1);
    end
else
    colorStream = repmat(color,nframes,1);
end
if(isfield(marker,'edgeColor'))
    edgeColor = marker.edgeColor;
else
    edgeColor = SCENE.options.markerEdgeColor;
end


s = PrimSphere([.0 .0 .0], d);

trans = stream';
vertices = s.vertices;
trans = repmat(trans',size(vertices,1),1);
trans = reshape(trans,3,[])';
vertstream = repmat(vertices,nframes,1) + trans;

% calculate the markers boundingbox and update scene bb
bb = [min(stream(1,:)); max(stream(1,:));...
    min(stream(2,:)); max(stream(2,:));...
    min(stream(3,:)); max(stream(3,:))];
    
if(~isempty(SCENE.status.boundingBox))
    SCENE.status.nframes = max(SCENE.status.nframes, nframes);
    oldbb = SCENE.status.boundingBox;
    xmin = min(oldbb(1),bb(1));
    xmax = max(oldbb(2),bb(2));
    ymin = min(oldbb(3),bb(3));
    ymax = max(oldbb(4),bb(4));
    zmin = min(oldbb(5),bb(5));
    zmax = max(oldbb(6),bb(6));
    newbb = [xmin;xmax;ymin;ymax;zmin;zmax];
    SCENE.status.boundingBox = newbb;
else
    SCENE.status.boundingBox = bb;
end

m = struct(...
    'faceAlphaStream',faceAlphaStream,...
    'colorStream',colorStream,...
    'type','marker',...
    'nframes',nframes,...
    'vertices',s.vertices,...
    'vertstream',vertstream,...
    'faces',s.faces,...
    'facecolor',color,...
    'edgecolor',edgeColor,...
    'labelHandle',[],...
    'labelStream',[],...
    'objectHandle',[]);

SCENE.markers(numMarkers) = m;
end