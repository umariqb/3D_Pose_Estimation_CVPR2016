function mot = extractMotFromDBmat(db,skel,varargin)
%extractMotFromDBmat extracts a motion from a db (e.g. obtained by buildDB)
%   You can extract...
%   - a complete motion by specifying its id in the db:
%     mot = extractMotFromDBmat(db,skel,10)
%     extracts motion nr 10 from the db
%   - a complete motion by specifying its filename in the db:
%     mot = extractMotFromDBmat(db,skel,db.motNames{10});
%   - a motion segment by specifying its start and end frame:
%     mot = extractMotFromDBmat(db,skel,10,100);
%   - a motion segment by specifying all its frames:
%     mot = extractMotFromDBmat(db,skel,[10,11,12,14,16,17,18,19,20]);
%
%   Remark: NaN values in frames are replaced by valid indices using
%   linear interpolation:
%   mot = extractMotFromDBmat(db,skel,[10,nan,12,14,16,17,18,nan,20]);
%   equals
%   mot = extractMotFromDBmat(db,skel,[10,11,12,14,16,17,18,19,20]);

switch nargin
    case 3
        getFrames = true;
        if isnumeric(varargin{1}) 
            if numel(varargin{1})==1
                id = varargin{1};
            else
                frames = varargin{1};
                getFrames = false;
                filename = '';
            end
        else
            [~,id] = ismember(varargin{1},db.motNames);
        end

        if getFrames
            if id>numel(db.motStartIDs)
                error('There are only %i motions in the db!',numel(db.motStartIDs));
            elseif id==numel(db.motStartIDs)
                startFrame = db.motStartIDs(id);
                endFrame = db.nrOfFrames;
            else
                startFrame = db.motStartIDs(id);
                endFrame = db.motStartIDs(id+1)-1;
            end
            frames = startFrame:endFrame;
            filename = db.motNames{id};
        end
    case 4
        startFrame = varargin{1};
        endFrame = varargin{2};
        if startFrame>endFrame || endFrame>db.nrOfFrames
            error('Wrong input.');
        end
        filename = '';
        frames = startFrame:endFrame;
    otherwise
        error('Wrong number of argins!');
end

if any(isnan(frames))
    x       = find(~isnan(frames));
    xi      = 1:numel(frames);
    frames  = round(interp1(x,frames(x),xi,'linear'));
end

if isfield(db,'quat')
    mot = buildMotFromRotData(double(db.quat(:,frames)),skel);
elseif isfield(db,'euler')
    mot = buildMotFromRotData(db.euler(:,frames),skel);
else
    error('No rotation data available!');
end

if isfield(db,'origRootOri') && isfield(db,'origRootPos')
    if iscell(mot.rotationQuat)
        mot.rotationQuat{1} = db.origRootOri(:,frames);
    else
        mot.rotationQuat(1:4,:) = db.origRootOri(:,frames);
    end
    mot.rootTranslation = double(db.origRootPos(:,frames));
elseif isfield(db,'deltaRootOri') && isfield(db,'deltaRootPos')
    for i=2:mot.nframes
        mot.rotationQuat{1}(:,i)=C_quatmult(mot.rotationQuat{1}(:,i-1),double(db.deltaRootOri(:,frames(i))));
    end

    for i=2:mot.nframes
        mot.rootTranslation(:,i)=mot.rootTranslation(:,i-1)+C_quatrot(double(db.deltaRootPos(:,frames(i))),mot.rotationQuat{1}(:,i));
    end
end

mot.jointTrajectories   = C_forwardKinematicsWrapper(skel,mot.rootTranslation,mot.rotationQuat);    %forwardKinematicsQuat(skel,mot);
mot.jointTrajectories   = mat2cell(mot.jointTrajectories,3*ones(mot.njoints,1),mot.nframes);
mot.boundingBox         = computeBoundingBox(mot);
mot.samplingRate        = db.frameRate;
mot.frameTime           = 1/mot.samplingRate;

if isfield(db,'motNames')
    mot.filename = filename;
end