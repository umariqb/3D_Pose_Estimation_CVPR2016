function setFrame(frame)
%SETFRAME function used for a scene, where the vertices are precalculated

global SCENE
numArmatures = SCENE.status.numArmatures;
numMarkers = SCENE.status.numMarkers;
for armature = 1:numArmatures
    % go to last frame of skel, if skel.nframes is < frame
    if(frame > SCENE.armatures(armature).mot.nframes)
        frameForSkel = SCENE.armatures(armature).mot.nframes;
    else
        frameForSkel = frame;
    end
    numBones = SCENE.armatures(armature).skel.njoints;
    for b = 1:numBones
        numVerts = size(SCENE.armatures(armature).bones(b).vertices,1);
        startIndex = ((frameForSkel-1)*numVerts+1);
        endIndex = startIndex - 1 + numVerts;
        currentVerts = SCENE.armatures(armature).bones(b).vertstream(startIndex:endIndex,:);
        if(SCENE.status.drawLabels)
            currentLabelPos = SCENE.armatures(armature).bones(b).labelStream(1:3,frameForSkel);
            set(SCENE.armatures(armature).bones(b).labelHandle,'Position',currentLabelPos);
        end
        set(SCENE.armatures(armature).bones(b).objectHandle,'Vertices',currentVerts);
    end
end
for i = 1:numMarkers
    if(frame > SCENE.markers(i).nframes)
        frameForMarker = SCENE.markers(i).nframes;
    else
        frameForMarker = frame;
    end
    numVerts = size(SCENE.markers(i).vertices,1);
    startIndex = ((frameForMarker-1)*numVerts+1);
    endIndex = startIndex - 1 + numVerts;
    currentVerts = SCENE.markers(i).vertstream(startIndex:endIndex,:);
    set(SCENE.markers(i).objectHandle,'vertices',currentVerts);
    set(SCENE.markers(i).objectHandle,'facealpha',...
        SCENE.markers(i).faceAlphaStream(frameForMarker));
    set(SCENE.markers(i).objectHandle,'facecolor',...
        SCENE.markers(i).colorStream(frameForMarker,:));
end

%setFrame for Objects
for i = 1:size(SCENE.animatedObjects,1)
    objID = SCENE.animatedObjects(i);
    obj = SCENE.objects(objID);
    if(frame > obj.nFrames)
        frameForObject = obj.nFrames;
    else
        frameForObject = frame;
    end
    numVerts = size(obj.vertices,1);
    startIndex = ((frameForObject-1)*numVerts+1);
    endIndex = startIndex - 1 + numVerts;
    currentVerts = obj.verticesStream(startIndex:endIndex,:);
    set(SCENE.objects(objID).objectHandle,'vertices',currentVerts);
    if(size(obj.faceAlphaStream,1)>1)
    set(SCENE.objects(objID).objectHandle,'facealpha',...
        SCENE.objects(objID).faceAlphaStream(frameForObject));
    end
    if(size(obj.faceColorStream,1)>1)
    set(SCENE.objects(objID).objectHandle,'facecolor',...
        SCENE.objects(objID).faceColorStream(frameForObject,:));
    end
end

% refresh status information
if ishandle(SCENE.status.sliderHandle)
    set(SCENE.status.sliderHandle,'Value',frame);
end
if ishandle(SCENE.status.curFrameLabel)
    set(SCENE.status.curFrameLabel,'String',...
        sprintf(' %d / %d',frame, SCENE.status.nframes));
end
curFPS = uint16(SCENE.status.curFps);
if (curFPS > SCENE.status.samplingRate)
    fps = sprintf('> %d fps', SCENE.status.samplingRate);
else
    fps = sprintf('%d fps', uint16(SCENE.status.curFps));
end
if ishandle(SCENE.status.curFpsLabel)
    set(SCENE.status.curFpsLabel, 'String',fps);
end
end