% function reverseMotion
% author: Jochen Tautges (tautges@cs.uni-bonn.de)

function mot = reverseMotion(skel,mot)

mot.rotationQuat        = cellfun(@(x) fliplr(x),mot.rotationQuat,'UniformOutput',0);
mot.filename            = [mot.filename '.reversed'];
mot.rootTranslation     = fliplr(mot.rootTranslation);
mot.jointTrajectories   = iterativeForwKinematics(skel,mot);