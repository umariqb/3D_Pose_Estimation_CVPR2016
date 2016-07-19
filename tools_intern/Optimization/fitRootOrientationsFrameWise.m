function [mot,qy,angles,localSystems] = fitRootOrientationsFrameWise(skel,mot,varargin)

defaultOptions.heading = [1;0;0]; % given in global system
defaultOptions.vector  = [1;0;0]; % given in root system

switch nargin
    case 2
        options = defaultOptions;
    case 3
        options = mergeOptions(varargin{1},defaultOptions);
end
    
if iscell(mot.rotationQuat)
    p       = C_quatrot(options.vector,mot.rotationQuat{1});
else
    p       = C_quatrot(options.vector,mot.rotationQuat(1:4,:));
end
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

% % % % % small hack to rotate all skeletons by 45deg for visualization
% % % % % crazypeople cluster means:
% % % % % qy2 = rotquat(45,'y');
% % % % % qy  = C_quatmult(qy,qy2);

if iscell(mot.rotationQuat)
    mot.rotationQuat{1}     = C_quatmult(qy,mot.rotationQuat{1});
else
    mot.rotationQuat(1:4,:)     = C_quatmult(qy,mot.rotationQuat(1:4,:));
end
% mot.rotationQuat{1} = repmat(sign(mot.rotationQuat{1}(1,:)),4,1).*mot.rotationQuat{1};
% recompute joint positions using forward kinematics
if iscell(mot.rotationQuat)
    [mot.jointTrajectories,localSystems] = iterativeForwKinematics(skel,mot);
else
    mot.jointTrajectories = C_forwardKinematicsWrapper(skel,mot.rootTranslation,mot.rotationQuat);
end
% mot.jointTrajectories = mat2cell(jointTrajMat,3*ones(1,skel.njoints));

% compute new Euler angles of root
% if ~isempty(mot.rotationEuler)
%     if ~isempty(mot.rotationEuler{1})
%         mot.rotationEuler{1} = C_quat2euler(C_quatmult(C_euler2quat(mot.rotationEuler{1}*pi/180),qy))*180/pi;
%     end
% end