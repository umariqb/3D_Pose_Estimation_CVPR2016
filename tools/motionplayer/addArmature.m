function addArmature(varargin)
% add armature to SCENE

global SCENE

skel = varargin{1};
mot = varargin{2};

numArmature = SCENE.status.numArmatures + 1;
% the color of the new armature
if(size(varargin,2) >= 3)
    if(isempty(varargin{3}))
        colorArmature = getColorByNum(numArmature);
    else
        colorArmature = varargin{3};
    end
else
    colorArmature = getColorByNum(numArmature);
end
if(size(varargin,2) >= 4)
    if(isempty(varargin{4}))
        edgeColorArmature = SCENE.options.skelEdgeColor;
    else
        edgeColorArmature = varargin{4};
    end
else
    edgeColorArmature = SCENE.options.skelEdgeColor;
end

animationTime = mot.nframes/mot.samplingRate;
frameTime = mot.frameTime;
nframes = mot.nframes;
bb = mot.boundingBox;

if(numArmature < 2)
    % if no skeleton has been loaded yet
    % set the fields of the SCENE to fields of the first skeleton
    SCENE.status.nframes = nframes;
    SCENE.status.frameTime = frameTime;
    SCENE.status.animationTime = animationTime;
    SCENE.status.boundingBox = bb;
    SCENE.status.samplingRate = mot.samplingRate;
    SCENE.status.curSkel = 1;
else
    % nframes,frameTime and animationTime = maximum of current status 
    % and the properties of the new armature
    SCENE.status.nframes = max(SCENE.status.nframes, nframes);
    SCENE.status.frameTime = max(SCENE.status.frameTime, frameTime);
    SCENE.status.animationTime = max(...
        SCENE.status.animationTime, animationTime);
    % calculate the new boundingbox as smallest box that contains all
    % skeletons
    oldbb = SCENE.status.boundingBox;
    xmin = min(oldbb(1),bb(1));
    xmax = max(oldbb(2),bb(2));
    ymin = min(oldbb(3),bb(3));
    ymax = max(oldbb(4),bb(4));
    zmin = min(oldbb(5),bb(5));
    zmax = max(oldbb(6),bb(6));
    newbb = [xmin;xmax;ymin;ymax;zmin;zmax];
    SCENE.status.boundingBox = newbb;
    SCENE.status.samplingRate = mot.samplingRate;
end
% set some fields to the SCENE.armature
SCENE.armatures(numArmature).skel = skel;
SCENE.armatures(numArmature).mot = mot;
SCENE.armatures(numArmature).numBones = skel.njoints;
SCENE.armatures(numArmature).color = colorArmature;
% create the bone-objects to the armature
SCENE.armatures(numArmature).bones = createBoneObjects(...
    skel, mot, colorArmature, edgeColorArmature);
SCENE.armatures(numArmature).rendered = false;
% preload all vertex positions of all bones in all frames
preloadVertexStream(numArmature);
%increase number of armatures of SCENE
SCENE.status.numArmatures = numArmature;
end