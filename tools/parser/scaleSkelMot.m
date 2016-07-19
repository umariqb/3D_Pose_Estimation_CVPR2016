function [skel,mot] = scaleSkelMot(skel,mot,S)
% [skel,mot] = scaleSkelMot(skel,mot,S)
% S is the downscale factor

for k=1:length(skel.nodes)
    skel.nodes(k).length = skel.nodes(k).length/S;
    skel.nodes(k).offset = skel.nodes(k).offset/S;
end
mot.rootTranslation = mot.rootTranslation/S;
mot.jointTrajectories = forwardKinematicsQuat(skel,mot);
mot.boundingBox = computeBoundingBox(mot);
