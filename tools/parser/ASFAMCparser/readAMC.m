function mot = readAMC(varargin)
% mot = readAMC(filename,skel,range,compute_quats,do_FK,use_TXT_or_BIN)

switch (nargin)
    case 1
        filename = varargin{1};
        skel  = getSkelFromAMC(filename);
        range = [-inf inf];
        compute_quats = true;
		do_FK = true;
        use_TXT_or_BIN = true;
    case 2
        filename = varargin{1};
        skel = varargin{2};
        range = [-inf inf];
        compute_quats = true;
		do_FK = true;
        use_TXT_or_BIN = true;
    case 3
        filename = varargin{1};
        skel = varargin{2};
        range = varargin{3};
        compute_quats = true;
		do_FK = true;
		use_TXT_or_BIN = true;
    case 4
        filename = varargin{1};
        skel = varargin{2};
        range = varargin{3};
        compute_quats = varargin{4};
		do_FK = true;
		use_TXT_or_BIN = true;
    case 5
        filename = varargin{1};
        skel = varargin{2};
        range = varargin{3};
        compute_quats = varargin{4};
		do_FK = varargin{5};
        use_TXT_or_BIN = true;
    case 6
        filename = varargin{1};
        skel = varargin{2};
        range = varargin{3};
        compute_quats = varargin{4};
		do_FK = varargin{5};
        use_TXT_or_BIN = varargin{6};
    otherwise
        error('Wrong number of arguments!');
end

mot = emptyMotion;
mot.samplingRate = 120;
mot.frameTime = 1/mot.samplingRate;

cl1 = clock;
%%%%%%%%%%%%%% open AMC file
fid = fopen(filename,'rt');
if fid ~= -1
    mot.njoints = skel.njoints;
    mot.jointNames = skel.jointNames;
    mot.boneNames = skel.boneNames;
    mot.nameMap = skel.nameMap;
    mot.animated = skel.animated;
    mot.unanimated = skel.unanimated;    
    
    idxBackSlash = findstr(filename, '\');
    if not(isempty(idxBackSlash))
        mot.filename = filename(idxBackSlash(end)+1:end);
    else
        mot.filename = filename;
    end
        
    mot.angleUnit = skel.angleUnit;

    mot = readSamplesPerSecond(mot,fid);
    
    if (use_TXT_or_BIN)
        % first try to read compact BIN version of the file
        h = fopen([filename '.BIN'],'r');
        if (h > 0) % does compact BIN file exist?
            [result,mot] = readFramesBIN(skel,mot,h,range);
        else
        % try reading compact TXT version of the file
            h = fopen([filename '.TXT'],'r');
            if (h > 0) % does compact TXT file exist?
                [result,mot] = readFramesTXT(skel,mot,h,range);
            else
                [result,mot] = readFrames(skel,mot,fid,range);
            end
        end
    else % don't use TXT or BIN format, resort to original AMC data
        [result,mot] = readFrames(skel,mot,fid,range);
    end

    fclose(fid);        
    if (~result)
        error(['AMC: Error reading frames from file ' filename '!']);
    end
else
    error('Could not open AMC file.');
end

t=etime(clock,cl1);
disp(['Read ' num2str(mot.nframes) ' frames from AMC file ' filename ' in ' num2str(t) ' seconds.']);


if (compute_quats)
%%%%%%%% convert rotation data to quaternion representation
    tic
    mot = convert2quat(skel,mot);
    t = toc;
    disp(['Converted motion data from ' mot.filename ' in ' num2str(t) ' seconds.']);
end


%%%%%% convert to metric motion!
inch2meter = 2.54;
mot.rootTranslation = mot.rootTranslation * inch2meter;

%%%%%%%%%%%%%%%%%% forward kinematics
if (do_FK)
tic
	if (compute_quats)
	    mot.jointTrajectories = forwardKinematicsQuat(skel,mot);
	else
	    mot.jointTrajectories = forwardKinematicsEuler(skel,mot);
	end
t = toc;
disp(['Computed joint trajectories from ' mot.filename ' in ' num2str(t) ' seconds.']);

%%%%%%%%%%%%%%%%%%%%%% bounding box
mot.boundingBox = computeBoundingBox(mot);
end


