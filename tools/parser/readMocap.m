function [skel,mot] = readMocap(skelfile, varargin)
% Reads file formats ASF/AMC, BVH or C3D into [skel, mot] structure.
% Possible calls:
%
%   [skel,mot] = readMocap(ASFfile, AMCfile, frameRange, compute_quats, do_FK, use_TXT_or_BIN, noCaching)
%   [skel,mot] = readMocap(BVHfile, frameRange, compute_quats, do_FK, noCaching)
%   [skel,mot] = readMocap(C3Dfile, frameRange, generateSkel, skelFitMethod, noCaching)
%                   where skelFitMethod can be 'ATS' (default), 'trans_heu', 'trans_opt' or 'none'.
%                   WARNING: If left empty, bone lengths will vary over time!

% set defaults

global VARS_GLOBAL;

if nargin < 1
    help readMocap
    return
end

motfile = skelfile;
range = [];
compute_quats = true;
do_FK = true;
use_TXT_or_BIN = true;
generateSkeleton = true;
skelFitMethod = 'ATS';
noCaching = false;

% parse Parameter list
fileExtension = upper(skelfile(end-3:end));
if strcmp(fileExtension, '.C3D')
    if nargin > 1, range = varargin{1}; end
    if nargin > 2, generateSkeleton = varargin{2}; end
    if nargin > 3, skelFitMethod = varargin{3}; end
    if nargin > 4, noCaching = varargin{4}; end 
    if isempty(skelFitMethod)
        skelFitMethod = 'ATS';
    end
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

matFullpath = [motfile '.mat'];
% csvFullpath = [motfile '.csv'];
% csvFullpath = strrep(csvFullpath,VARS_GLOBAL.dir_root,VARS_GLOBAL.dir_additional);
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
%             mot.csvFile = csvFullpath;
%             [mot.Labels,mot.Data] = BK_load_csv(csvFullpath);
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
            save(matFullpath, 'skel', 'mot');
        case '.ASF'
            skel = readASF(skelfile);
            mot = readAMC(motfile,skel,range,compute_quats,do_FK,use_TXT_or_BIN);
%             mot.csvFile = csvFullpath;
%             mot.Labels = {};
%             mot.Data = {};
           save(matFullpath, 'skel', 'mot');
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
    % generate Skeleton if needed
    if generateSkeleton
        [skel, mot] = generateSkel(skel, mot);
        if not(strcmpi(skelFitMethod, 'none'))
            switch(upper(skelFitMethod))
                case 'ATS'
                    mot = skelfitATS(mot);
                case 'TRANS_HEU'
                    mot = skelfitH(mot, 'boneNumbers', 0.15);
                case 'TRANS_OPT'
                    mot = skelfitOptT(mot);
                otherwise
                    error('Unknown skelfit method!');
            end
        end
    end
end