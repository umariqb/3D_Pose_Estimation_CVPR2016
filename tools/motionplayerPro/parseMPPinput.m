function parseMPPinput(varargin)

    global SCENE;
    
    for i=1:2:nargin
        switch varargin{i}
            case 'skel'
                if iscell(varargin{i+1})
                    skel = varargin{i+1};
                    SCENE.nskels = numel(varargin{i+1});
                else
                    SCENE.nskels = 1;
                    skel = {varargin{i+1}};
                end
            case 'mot'
                if iscell(varargin{i+1})
                    SCENE.mots = varargin{i+1};
                    SCENE.nmots = numel(varargin{i+1});
                else
                    SCENE.nmots = 1;
                    SCENE.mots = {varargin{i+1}};
                end
            case 'points'
                if iscell(varargin{i+1})
                    SCENE.points = varargin{i+1};
                    SCENE.npoints = numel(varargin{i+1});
                else
                    SCENE.npoints = 1;
                    SCENE.points = {varargin{i+1}};
                end
        end
    end

    if SCENE.nmots<1
        error('No mots specified!');
    end
    if SCENE.nskels<1
        error('No skels specified!');
    end
    if SCENE.nmots~=SCENE.nskels
        if SCENE.nskels==1
            SCENE.skels(1:SCENE.nmots) = skel;
        else
            error('Number of skels must be 1 or equal number of mots!');
        end
    else
        SCENE.skels=skel;
    end
end