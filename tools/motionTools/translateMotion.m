% function translateMotion
% translates a motion with specified translation
% mot = translateMotion(skel,mot,x,y,z)
% author: Jochen Tautges (tautges@cs.uni-bonn.de)

function mot = translateMotion(skel,mot,x,y,z,varargin)
computetrajsbb=true;
if (nargin ==  6)
    computetrajsbb=varargin{1};
end

mot.rootTranslation(1,:)  = mot.rootTranslation(1,:)+x;
mot.rootTranslation(2,:)  = mot.rootTranslation(2,:)+y;
mot.rootTranslation(3,:)  = mot.rootTranslation(3,:)+z;

if (computetrajsbb)
    mot.jointTrajectories = C_forwardKinematicsQuat(skel,mot);
    mot.boundingBox       = computeBoundingBox(mot);
end

if (isfield(mot,'jointVelocities')&&~isempty(mot.jointVelocities) && mot.nframes>1)
    mot = addVelToMot(mot);
end
if (isfield(mot,'jointAccelerations')&&~isempty(mot.jointAccelerations) && mot.nframes>1)
    mot = addAccToMot(mot);
end
%fprintf('Motion successfully translated with x=%.2f, y=%.2f, z=%.2f.\n',x,y,z);