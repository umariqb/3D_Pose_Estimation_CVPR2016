% function C_rotateMotion
% rotates a motion with specified angle (in radians) around specified axis
% mot = rotateMotion(skel,mot,angle,axis,varargin)
% if varargin = false, jointTrajectories and boundingBox won't be computed
% author: Jochen Tautges (tautges@cs.uni-bonn.de), 
% some modifications by Tim Golla (tim.golla@gmx.de)

function mot = C_rotateMotion(skel,mot,angle,axis,varargin)
computetrajsbb=true;
if (nargin ==  5)
    computetrajsbb=varargin{1};
end

Q = rotquat(angle,axis);

for i=1:mot.nframes
    mot.rootTranslation(:,i) = C_quatrot(mot.rootTranslation(:,i),Q);
    mot.rotationQuat{1}(:,i) = C_quatmult(Q,mot.rotationQuat{1}(:,i));
end

if (computetrajsbb)
    mot.jointTrajectories = C_forwardKinematicsQuat(skel,mot);
    mot.boundingBox       = computeBoundingBox(mot);
end

if ~(isempty(mot.rotationEuler))
    mot               = C_convert2euler(skel,mot);
%     mot.rotationEuler{1} = flipud(quat2euler(mot.rotationQuat{1},'zyx'))*180/pi;
end
if (isfield(mot,'jointVelocities') && ~isempty(mot.jointVelocities) && mot.nframes>1)
    mot = addVelToMot(mot);
end
if (isfield(mot,'jointAccelerations') && ~isempty(mot.jointAccelerations) && mot.nframes>1)
    mot = addAccToMot(mot);
end
%fprintf('Motion successfully rotated with %.2f degrees around %c-axis.\n',angle*180/pi,axis);