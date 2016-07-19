% function removeOrientation
% removes the global orientation (root orientation) of a motion
% mot = removeOrientation(skel,mot)
% author: Jochen Tautges (tautges@cs.uni-bonn.de)

function mot = removeOrientation(skel,mot)

if ~(isempty(mot.rotationQuat))
    mot.rotationQuat{1}=[ones(1,mot.nframes);zeros(3,mot.nframes)];
end
if ~(isempty(mot.rotationEuler))
    mot.rotationEuler{1}=zeros(size(mot.rotationEuler{1}));
end

mot.jointTrajectories=forwardKinematicsQuat(skel,mot);
mot.boundingBox=computeBoundingBox(mot);

if (isfield(mot,'jointVelocities')&&~isempty(mot.jointVelocities))
    mot=addVelToMot(mot);
end
if (isfield(mot,'jointAccelerations')&&~isempty(mot.jointAccelerations))
    mot=addAccToMot(mot);
end