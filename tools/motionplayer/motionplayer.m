function motionplayer(varargin)
%MOTIONPLAYER plays motions of the ASF/AMC format.
%
%start the motionplayer:
%   motionplayer()
%
%load one motion at start:
%   motionplayer('skel', {skel}, 'mot', {mot}, 'marker',{marker})
%   skel: <Nx1 cell> each cell is a struct:
%         struct(...
%            'njoints',<int>,...
%            'nodes',<Nx1 struct>,...
%            'paths',<Nx1 cell>,...
%            'filename',<string>,...
%            'name',<string>);
%   mot:  <Nx1 cell> each cell is a struct:
%         struct(...
%            'njoints',<int>,...
%            'nframes',<int>,...
%            'frameTime',<double>,...
%            'samplingRate',<double>,...
%            'jointTrajectories',<Nx1 cell>,...
%            'boundingBox',<6x1 double>,...
%            'filename',<string>);
%   marker: <Nx1 cell> each cell is a struct:
%         struct(...
%           'stream',<3xN double>,...
%           'color',<1x3 double>,...
%           'size',<double>);
%
%load multible motions at start:
%   motionplayer('skel', {skel1, skel2, ...},...
%                'mot', {mot1, mot2, ...},...
%                'marker', {marker1, marker3, marker6,...})

global SCENE
SCENE = emptyScene;

%% using inputParser function to handle variable inputs
p = inputParser;
% p.FunctionName = 'validate skel- and mot-structures.';
p.addOptional('skel', [], @(x)isSkel(x));
p.addOptional('mot', [], @(x)isMot(x));
p.addOptional('color', [], @(x)isColor(x));
p.addOptional('edgecolor', [], @(x)isColor(x));
p.addOptional('marker', [], @(x)isMarker(x));
p.addOptional('light',[]);
p.addOptional('object',[]);
p.addOptional('options', []);
p.parse(varargin{:});

defaultOptions = getDefaultOptions();

if(~isempty(p.Results.options))
    SCENE.options = evalFields(defaultOptions, p.Results.options);
else
    SCENE.options = defaultOptions;
end

if(size(varargin,2) == 0)
    SCENE.sceneIsEmpty = true;
else
    SCENE.sceneIsEmpty = false;
end
%%
% create armatures
if(~isempty(p.Results.skel) && ~isempty(p.Results.mot))
    if(size(p.Results.skel,2)~=size(p.Results.mot,2))
        fprintf('ERROR:\n Number of skeletons must be equal to number of motions!\n');
        return;
    else
        % get armature color from input
        if(~isempty(p.Results.color))
            if(size(p.Results.skel,2) ~= size(p.Results.color))
                fprintf('ERROR:\n Number of colors must be equal to number of motions!\n');
                return;
            else
                colorArmature = p.Results.color;
            end
        else
            colorArmature = [];
        end
        
        % get armature edgecolor from input
        if(~isempty(p.Results.edgecolor))
            if(size(p.Results.skel,2) ~= size(p.Results.edgecolor))
                fprintf('ERROR:\n Number of edgecolors must be equal to number of motions!\n');
                return;
            else
                edgeColorArmature = p.Results.edgecolor;
            end
        else
            edgeColorArmature = [];
        end
        
        colorSpec = struct('color',[],'edgecolor',[]);
        for i = 1:size(p.Results.skel,2)
            if(~isempty(colorArmature))
                if(~isempty(edgeColorArmature))
                    colorSpec.color = colorArmature{i};
                    colorSpec.edgecolor = edgeColorArmature{i};
                else
                    colorSpec.color = colorArmature{i};
                    colorSpec.edgecolor = [];
                end
            else
                if(~isempty(edgeColorArmature))
                    colorSpec.color = [];
                    colorSpec.edgecolor = edgeColorArmature{i};
                else
                    colorSpec.color = [];
                    colorSpec.edgecolor = [];
                end
            end
            addArmature(p.Results.skel{1,i}, p.Results.mot{1,i},...
                colorSpec.color, colorSpec.edgecolor);
        end
    end
end
%%
% create markers
if(~isempty(p.Results.marker))
    for i = 1:size(p.Results.marker,2)
        addMarker(p.Results.marker{i});
    end
end

% create objects
if(~isempty(p.Results.object))
    for i = 1:size(p.Results.object,2)
        obj = p.Results.object{i};
        if iscell(obj)
            for j = 1 : size(obj,1)
                for k = 1 : size(obj,2)
                    objectIn = obj{j,k};
                    objPart = getObject(objectIn);
                    addObjectToScene(objPart);
                end
            end
        else
            obj = getObject(p.Results.object{i});
            addObjectToScene(obj);
        end
    end
end

if (~isempty(SCENE.status.boundingBox))
    if(SCENE.options.groundPlane)
        tileSize = SCENE.options.groundPlaneTileSize;
        color1 = SCENE.options.groundPlaneColor(1,:);
        color2 = SCENE.options.groundPlaneColor(2,:);
        alpha = SCENE.options.groundPlaneAlpha;
        % create objects
        [tiles1, tiles2] =  PrimGroundplane(SCENE.status.boundingBox,...
            tileSize, color1, color2, alpha);
        addObjectToScene(tiles1);
        addObjectToScene(tiles2);
    end
end

%% start gui
fig = motionplayergui();
SCENE.fig = fig;

%% add lightsources to scene
if(~isempty(p.Results.light))
    for i = 1:size(p.Results.light,2)
        % get default light object
        defaultLight = getLight();
        userLight = p.Results.light{i};
        l = evalFields(defaultLight,userLight);
        light(...
            'Color',l.color,...
            'Position',l.position,...
            'Style',l.style...
            );
    end
end
    
if(SCENE.options.light)
    boundingBox = SCENE.status.boundingBox;
    xmin = boundingBox(1);
    xmax = boundingBox(2);
    ymin = boundingBox(3);
    ymax = boundingBox(4);
    zmin = boundingBox(5);
    zmax = boundingBox(6);
    d1 = [...
        xmax,...
        ymax,...
        zmax];
    d2 = [...
        xmin,...
        ymax,...
        zmin];
    posLight1 = d1;
    posLight2 = d2;
    light('Position',posLight1,'Style','local','Color',[.0 .0 .0]);
    light('Position',posLight2,'Style','local','Color',[.0 .0 .0]);
    %     plot3(posLight1(1),posLight1(2),posLight1(3),'o');
    %     hold on
    %     plot3(posLight2(1),posLight2(2),posLight2(3),'o');
    %     axis equal
end

%% render objects
if(~SCENE.sceneIsEmpty)
    renderScene();
    % render armatures
    for armature = 1:SCENE.status.numArmatures
        renderArmature(armature);
    end
    if (SCENE.status.numMarkers > 0)
        renderMarkers();
    end
    % set scene to frame 1
    setFrame(1);
    SCENE.status.curFrame = 1;
end

%% input validation functions
%validate color arguments
    function out = isColor(col)
        out = true;
        for i = 1:max(size(col,1),size(col,2))
            c = col{i};
            if(ischar(c))
                if (~strcmp(c,'none'))
                    out = false;
                    return;
                end
            elseif((size(c,1) == 1 && size(c,2) == 3) || ...
                    (size(c,1) == 3 && size(c,2) == 1))
                if(min(c)<0 || max(c) >1)
                    out = false;
                    return;
                end
            else
                out = false;
                return;
            end
        end
    end

%evaluate user fields
    function options = evalOptions(userOpts)
        options = defaultOptions;
        defaultFields = fieldnames(options);
        for i = 1:size(defaultFields,1);
            f = defaultFields{i};
            if(isfield(userOpts,f))
                s = ['options.' f '= userOpts.' f ';'];
                eval(s);
            end
        end
    end
end