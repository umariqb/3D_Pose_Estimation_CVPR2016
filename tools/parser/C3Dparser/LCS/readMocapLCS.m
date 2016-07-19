function [skel,mot] = readMocapLCS(skelfile, varargin)
% Reads file formats ASF/AMC, BVH or C3D into [skel, mot] structure.
% Possible calls:
%
%   [skel,mot] = readMocapLCS(ASFfile, AMCfile, frameRange, compute_quats, do_FK, use_TXT_or_BIN, noCaching)
%   [skel,mot] = readMocapLCS(BVHfile, frameRange, compute_quats, do_FK, noCaching)
%   [skel,mot] = readMocapLCS(C3Dfile, frameRange, generateSkel, noCaching)


if nargin < 1
    help readMocapLCS
    return
end

% set defaults
motfile = skelfile;
range = [];
compute_quats = true;
do_FK = true;
use_TXT_or_BIN = true;
generateSkeleton = true;
noCaching = false;

% parse Parameter list
fileExtension = upper(skelfile(end-3:end));
if strcmp(fileExtension, '.C3D')
    if nargin > 1, range = varargin{1}; end
    if nargin > 2, generateSkeleton = varargin{2}; end
    if nargin > 3, noCaching = varargin{3}; end
elseif strcmp(fileExtension, '.ASF')
    if nargin > 1, motfile = varargin{1}; end
    if nargin > 2, range = varargin{2}; end
    if nargin > 3, compute_quats = varargin{3}; end
    if nargin > 4, do_FK = varargin{4}; end 
    if nargin > 5, use_TXT_or_BIN = varargin{5}; end 
    if nargin > 6, noCaching = varargin{6}; end 
elseif strcmp(fileExtension, '.BVH')
    if nargin > 1, range = varargin{1}; end
    if nargin > 2, compute_quats = varargin{2}; end
    if nargin > 3, do_FK = varargin{3}; end
    if nargin > 4, noCaching = varargin{4}; end 
else
    error(['Unknown file extension: ' fileExtension]);
end

% Caching
writeMAT = false;  % write a MAT-file?
existsMAT = false;

matFullpath = [motfile '.MAT'];
if ~noCaching
    h = fopen(matFullpath);
    % does MAT version already exist?
    if (h~=-1) 
        fclose(h);
        load(matFullpath, 'skel', 'mot');
        existsMAT = true;
        
        % in case of C3D we have to check whether the *.MAT file contains a
        % skeleton or not. This should not be the case but who knows...
        % maybe someone saved a version with a generated skeleton.
        if strcmp(fileExtension, '.C3D') 
            if isempty(strmatch('root', skel.nameMap(:,1))) % if no root-joint present => marker based
                if generateSkeleton
                    ;  % we want a skeleton but did not get one: Construct it later
                else
                    return;     % we did not get a skeleton and don't want one => good! :-)
                end
            else
                if generateSkeleton
                    disp('WARNING:');
                    disp('Keeping skeleton-version of cached MAT-file... check bone length constraints!');
                    return;     % we got a skeleton and want it => good! :-)
                else
                    writeMAT = true; % parse again, because we got a skeleton-based MAT-file but don't want it
                end  
            end
        else
            return; % in case of BVH or ASF/AMC, use the cached version 
        end
    else
        writeMAT = true;
    end
end

% delegate to parser
if ~existsMAT
    switch (fileExtension)
        case '.BVH'
            [skel,mot] = readBVH(skelfile,range,compute_quats,do_FK);
        case '.ASF'
            skel = readASF(skelfile);
            mot = readAMC(motfile,skel,range,compute_quats,do_FK,use_TXT_or_BIN);
        case '.C3D'
            [Markers,VideoFrameRate,AnalogSignals,AnalogFrameRate,Event,ParameterGroup,CameraInfo,ResidualError] = readC3d(skelfile);
            [skel, mot] = convert(Markers, ParameterGroup, VideoFrameRate, skelfile);
            
            % save *.MAT
            if writeMAT
                save(matFullpath, 'skel', 'mot');
            end
    end
end

if strcmp(fileExtension, '.C3D')
    if generateSkeleton
        [skel, mot] = generateLCS(skel, mot);
        mot = skelfitATS(mot);
    end
end