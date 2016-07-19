% function warpMotion
% performs Dynamic Time Warping (DTW)
% warps a motion with respect to specified warping path
% WarpedMotion = warpMotion(path,skel,motion)
% (use pointCloudDTW for example to compute warping path)
% author: Jochen Tautges (tautges@cs.uni-bonn.de)


function WarpedMotion = warpMotion(path,skel,motion)

pathorg = path;
path = alignpathlocal(path);

targetMotionLength  = path(1,1);
motionLength        = length(path);
path                = flipud(path);
frames              = cell(1,targetMotionLength);

WarpedMotion        = motion;
WarpedMotion.nframes = targetMotionLength;
njoints             = motion.njoints;

if isfield(motion,'jointAccelerations')
    computeAccelerations = true;
else
    computeAccelerations = false;
end
if isfield(motion,'jointVelocities')
    computeVelocities    = true;
else
    computeVelocities = false;
end

path_tmp = path; 
c=1;
for n=2:motionLength
    if path_tmp(n,2)==path_tmp(n-1,2) %Wie oft muß ein Frame der Ursprungsbewegung wiederholt werden?
        c=c+1;
    else % Wenn fertig: ?
        if c>1
            for i=1:c
                if n-c==1
                    path(n-c-1+i,2)=path_tmp(n-c-1+i,2)+(i-1)/c;
                else
                    path(n-c-1+i,2)=path_tmp(n-c-1,2)+i*2/(c+1);
                end
            end
            c=1;
        end
    end
end
% Frames zuordnen, in cell array, jede cell kann mehrere Frames der 
% Ursprungsbewegung enthalten
for n=1:motionLength
    frames{path(n,1)}=[frames{path(n,1)} path(n,2)];
end

if ~(isempty(motion.rotationQuat))
    for i=1:njoints
        if ~(isempty(motion.rotationQuat{i}))
            WarpedMotion.rotationQuat{i} = quatnormalize(warpTrajectories(motion.rotationQuat{i},frames));
        end
    end
    WarpedMotion.rootTranslation    = warpTrajectories(motion.rootTranslation,frames);
    WarpedMotion.jointTrajectories  = iterativeForwKinematics(skel,WarpedMotion);
    WarpedMotion.boundingBox        = computeBoundingBox(WarpedMotion);
    if ~(isempty(WarpedMotion.rotationEuler))
        WarpedMotion                = convert2euler(skel,WarpedMotion);
    end
elseif ~(isempty(WarpedMotion.rotationEuler))
    for i=1:njoints
        if ~(isempty(motion.rotationEuler{i}))
            WarpedMotion.rotationEuler{i} = warpTrajectories(motion.rotationEuler{i},frames);
        end
    end
    WarpedMotion                    = convert2quat(skel,WarpedMotion);
    WarpedMotion.jointTrajectories  = forwardKinematicsQuat(skel,WarpedMotion);
    WarpedMotion.boundingBox        = computeBoundingBox(WarpedMotion);
else
    if ~(isempty(WarpedMotion.jointTrajectories))
        for i=1:njoints
            if ~(isempty(motion.jointTrajectories{i}))
                WarpedMotion.jointTrajectories{i}  = warpTrajectories(motion.jointTrajectories{i},frames); 
            end
        end
        if ~(isempty(WarpedMotion.jointVelocities))
            WarpedMotion            = addVelToMot(WarpedMotion);
        end
        if ~(isempty(WarpedMotion.jointAccelerations))
            WarpedMotion            = addAccToMot(WarpedMotion);
        end   
    else
        if (isfield(WarpedMotion,'jointVelocities') && ~(isempty(WarpedMotion.jointVelocities)))
            computeVelocities=false;
%             fprintf('Velocities are being warped...\n');
            for i=1:njoints
                if ~(isempty(motion.jointVelocities{i}))
                    WarpedMotion.jointVelocities{i}  = warpTrajectories(motion.jointVelocities{i},frames);
                end
            end
        end
        if (isfield(WarpedMotion,'jointAccelerations') && ~(isempty(WarpedMotion.jointAccelerations)))
            computeAccelerations=false;
%             fprintf('Accelerations are being warped...\n');
            for i=1:njoints
                if ~(isempty(motion.jointAccelerations{i}))
                    WarpedMotion.jointAccelerations{i}  = warpTrajectories(motion.jointAccelerations{i},frames);
                end
            end
        end
    end
        
end

if computeAccelerations
    WarpedMotion=addAccToMot(WarpedMotion);
end
if computeVelocities
    WarpedMotion=addVelToMot(WarpedMotion);
end

WarpedMotion.nframes = size(WarpedMotion.rootTranslation,2);

end

% local function
function warpedTrajectories = warpTrajectories(trajectories,frames)
targetMotionLength = length(frames);
warpedTrajectories = [];

for frame=1:targetMotionLength
    if mod(frames{frame},1)==0
        warpedTrajectories =    [warpedTrajectories mean(trajectories(:,frames{frame}),2)];
    else
        fact=mod(frames{frame},1);
        warpedTrajectories =    [warpedTrajectories...
                                trajectories(:,floor(frames{frame}))*(1-fact)'...
                                +   trajectories(:,ceil(frames{frame}))*fact'];
    end
end
end
% end of local function

function rpath = alignpathlocal(path)

    rpath = path(1,:);
    for s=2:size(path,1)
        
        if all(path(s,:)==(path(s-1,:)-[2 1]))
            rpath = [rpath; rpath(end,:)-1;path(s,:)];
        elseif all(path(s,:)==(path(s-1,:)-[1 2]))
            rpath = [rpath; rpath(end,:)-1;path(s,:)];
        else
            rpath = [rpath; path(s,:)];
        end
        
    end
    
end
