% function translateMotion
% translates a motion with specified translation
% mot = translateMotion(skel,mot,x,y,z)
% author: Jochen Tautges (tautges@cs.uni-bonn.de)

function mot = translateMotion(skel,mot,x,y,z)

mot.rootTranslation     = mot.rootTranslation+repmat([x;y;z],1,mot.nframes);

mot.jointTrajectories = forwardKinematicsQuat(skel,mot);
mot.boundingBox       = computeBoundingBox(mot);

if (isfield(mot,'jointVelocities')&&~isempty(mot.jointVelocities))
    mot=addVelToMot(mot);
end
if (isfield(mot,'jointAccelerations')&&~isempty(mot.jointAccelerations))
    mot=addAccToMot(mot);
end
%fprintf('Motion successfully translated with x=%.2f, y=%.2f, z=%.2f.\n',x,y,z);