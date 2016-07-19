function motionplayer_old(varargin)
%MOTIONPLAYER plays motions of the ASF/AMC format.
%
%start the motionplayer:
%   motionplayer_old()
%
%load N = 1..n motions at start:
%   motionplayer_old(skel_1, skel_2, ..., skel_N, mot_1, mot_2, ..., mot_N)
%   the number of skels must be equal to the number of mots
%   skel_i corresponds to mot_i
% 
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

global SCENE
SCENE = emptyScene;

defaultOptions = struct(...
    'resolution',1.0,...        % resolution of sphere objects [1.0,3.0]
    'groundPlane',true,...      % draw groundplane [true/false]
    'groundPlaneColor',[.7 .7 .7;...    %color1 and color2 of tiles [2x3]
    1 1 1],...
    'groundPlaneTileSize',20,...
    'skelEdgeColor',[.0 .0 .0],...
    'markerEdgeColor',[.0 .0 .0],...
    'ambientStrength',1.0,...
    'diffuseStrength',1.0,...
    'specularStrength',1.0,...
    'light',false,...
    'doTheMonkey',struct('size',0,'orientation',[1.0 0.0 0.0 0.0]') ...
    );                          %scalar for size of the monkey-head 
                                %doTheMonkey == 0 -> default sphere, 
                                %doTheMonkey > 0 -> monkey head (value
                                %should be 2.5 to 5


SCENE.options = defaultOptions;

if(size(varargin,2) == 0)
    SCENE.sceneIsEmpty = true;
else
    SCENE.sceneIsEmpty = false;
end

% create armatures

if(size(varargin,2)>=2)
    if(mod(size(varargin,2),2) ~= 0)
        fprintf('ERROR:\n Number of skeletons must be equal to number of motions!\n');
        return;
    else
        for i = 1:(size(varargin,2)/2)
            m = size(varargin,2)/2 + i;
            addArmature(varargin{1,i}, varargin{1,m});
        end
    end
end

if (~isempty(SCENE.status.boundingBox))
    % create objects
    [tiles1, tiles2] =  PrimGroundplane(SCENE.status.boundingBox);
    addObjectToScene(tiles1);
    addObjectToScene(tiles2);
end

% start gui
fig = motionplayergui_old();

% render objects
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

% this function adds different types of 3d objects to the scene
    function addObjectToScene(obj)
        SCENE.numObjects = SCENE.numObjects + 1;
        obj.id = SCENE.numObjects;
        SCENE.objects(SCENE.numObjects) = obj;
    end
    


% returns true if given argument is a marker-type structure
    function out = isMarker(marker)
        fieldsRequired = {'stream', 'color','size'};
        for i = 1:size(marker,2)
            m = marker{1,i};
            if(isstruct(m))
                fieldsInMarker = fieldnames(m);
                for f = fieldsRequired
                    if (any(strcmp(f,fieldsInMarker)))
                    else
                        out = false;
                        fprintf('marker is not valid: \n\t field ''%s'' is missing\n', f{1,1});
                        break;
                    end
                    out = true;
                end
            else
                out = false;
                fprintf('type mismatch on ''marker'': type struct expected\n');
                break;
            end
        end
        if(out == false)
            r = '';
            for f = fieldsRequired
                r = strcat('''',f{1,1},'''',',', r);
            end
            r = strcat('fields required for marker: \n\t(',r,')\n');
            fprintf(r);
        end
    end
end