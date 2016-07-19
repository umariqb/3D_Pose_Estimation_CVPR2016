function skel = buildResizedSkel(mot, targetSkel, boneLengths, skelTree, idxStart1, idxStart2)

nJoints = length(mot.jointTrajectories);

% idxLtoes = strmatch('ltoes', mot.nameMap(:,1));
% idxLankle = strmatch('lankle', mot.nameMap(:,1));
 
% skel{idxLtoes} = mot.jointTrajectories{idxLtoes}(:,frame);
skel{idxStart1} = targetSkel{idxStart1};
skel = attachBone( idxStart1, idxStart2, skel, skelTree, targetSkel, boneLengths );
