function [skel,mot] = readBVH(varargin)
% skel,mot] = readBVH(filename,range,compute_quats,do_FK)

switch (nargin)
    case 1
        filename = varargin{1};
        range = [-inf inf];
        compute_quats = true;
		do_FK = true;
    case 2
        filename = varargin{1};
        range = varargin{2};
        compute_quats = true;
		do_FK = true;
    case 3
        filename = varargin{1};
        range = varargin{2};
        compute_quats = varargin{3};
		do_FK = true;
    case 4
        filename = varargin{1};
        range = varargin{2};
        compute_quats = varargin{3};
		do_FK = varargin{4};
    otherwise
        error('Wrong number of arguments!');
end

cl1 = clock;
%%%%%%%%%%%%%% open BVH file
fid = fopen(filename,'rt');
if fid ~= -1
%%%%%%%%%%%%%% read HIERARCHY
    skel = emptySkeleton;
    skel.filename = filename;
    skel.fileType = 'BVH';
    skel.name = 'BVH';

    [result, skel] = readHierarchyBVH(skel,fid);
    if ~result
        close(hF);
        fclose(fid);
        error('Error parsing HIERARCHY section in BVH file.');
    end
    
    if (nargout>1) % "read motion" requested by user
%%%%%%%%%%%%%% read MOTION
        mot = emptyMotion;
        mot.filename = filename;
        mot.nameMap = skel.nameMap;
        
        [result, mot, skel] = readMotion(mot,skel,fid, range, compute_quats);
        if ~result
            close(hF);
            error('Error parsing MOTION section in BVH file.');
        end
        
	%    fclose(fid); % this is done by readMotion
    else
        fclose(fid);        
    end
else
    error('Could not open BVH file.');
end

if (do_FK)
	tic
	if (compute_quats)
	    mot.jointTrajectories = forwardKinematicsQuat(skel,mot);
	else
	    mot.jointTrajectories = forwardKinematicsEuler(skel,mot);
	end
	t = toc;
	disp(['Computed joint trajectories from ' mot.filename ' in ' num2str(t) ' seconds.']);
	mot.boundingBox = computeBoundingBox(mot);
end

t=etime(clock,cl1);
disp(['Total elapsed time : ' num2str(t) ' seconds.']);


