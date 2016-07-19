function [mot,qy,angles,localSystems] = C_fitRootOrientationsFrameWise(skel,mot,varargin)

defaultOptions.heading = [1;0;0]; % given in global system
defaultOptions.vector  = [1;0;0]; % given in root system

switch nargin
    case 2
        options = defaultOptions;
    case 3
        options = mergeOptions(varargin{1},defaultOptions);
end

if iscell(mot.rotationQuat)
    rootRotation = mot.rotationQuat{1};
else
    rootRotation = mot.rotationQuat(1:4,:);
end

p       = C_quatrot(options.vector,rootRotation);
p(2,:)  = 0;
p       = normalizeColumns(p);

v       = options.heading;
v(2)    = 0;
v       = repmat(normalizeColumns(v),1,double(mot.nframes));

% compute angles to rotate character framewise
angles      = real(acos(dot(p,v)));
idx         = acos(dot(repmat([0;1;0],1,mot.nframes),normalizeColumns(cross(p,v))))>pi/2;
angles(idx) = -angles(idx);

% rotate motion about y-axis
qy                      = rotquat(angles,'y');
rootRotation     = C_quatmult(qy,rootRotation);


do_forwardKinematics = true;

if iscell(mot.rotationQuat)
    mot.rotationQuat{1} = rootRotation;
    if length(mot.rotationQuat)==1, do_forwardKinematics = false; end;
else
    mot.rotationQuat(1:4,:) = rootRotation;
    if size(mot.rotationQuat,1)==4, do_forwardKinematics = false; end;
end

if do_forwardKinematics
    % mot.rotationQuat{1} = repmat(sign(mot.rotationQuat{1}(1,:)),4,1).*mot.rotationQuat{1};
    % recompute joint positions using forward kinematics
    % [mot.jointTrajectories,localSystems] = iterativeForwKinematics(skel,mot);
    localSystems = 'calculation removed in C_fitRootOrientationFrameWise Line 32! Could be returned by C_forwardKinematics.';
    jointTrajMat          = C_forwardKinematicsWrapper(skel,mot.rootTranslation,mot.rotationQuat);
    mot.jointTrajectories = mat2cell(jointTrajMat,3*ones(1,skel.njoints));
else
    %warning('Only root quaternion given for normalization, no forward kinematics possible!');
    if iscell(mot.jointTrajectories)
        for i=1:length(mot.jointTrajectories)
            mot.jointTrajectories{i} = quatrot(mot.jointTrajectories{i},qy);
        end
    else
        for i=1:mot.njoints
            mot.jointTrajectories(4*i-3:4*i,:) = quatrot(mot.jointTrajectories(4*i-3:4*i,:),qy);
        end
    end
end

% compute new Euler angles of root
% if ~isempty(mot.rotationEuler)
%     if ~isempty(mot.rotationEuler{1})
%         mot.rotationEuler{1} = C_quat2euler(C_quatmult(C_euler2quat(mot.rotationEuler{1}*pi/180),qy))*180/pi;
%     end
% end