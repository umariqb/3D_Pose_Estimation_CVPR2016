% function mirrorMot
% mirrors specified skeleton and motion on the yz-plane
% [newskel,newmot] = mirrorMot(skel,mot)
% author: Jochen Tautges (tautges@cs.uni-bonn.de)

function [newskel,newmot]=mirrorMot(skel,mot)

newskel = mirrorSkel(skel);

% if isempty(mot.rotationEuler)
    mot = C_convert2euler(skel,mot);
% end

newmot = mot;
newmot.rootTranslation(1,:) = -newmot.rootTranslation(1,:);

pairs{1}    = [6,11];
pairs{2}    = [5,10];
pairs{3}    = [9,4];
pairs{4}    = [3,8];
pairs{5}    = [2,7];
pairs{6}    = [18,25];
pairs{7}    = [19,26];
pairs{8}    = [20,27];
pairs{9}    = [21,28];
pairs{10}   = [22,29];
pairs{11}   = [23,30];
pairs{12}   = [24,31];

for i=1:length(pairs)
    newmot.rotationEuler{pairs{i}(1)} = mot.rotationEuler{pairs{i}(2)};
    newmot.rotationEuler{pairs{i}(2)} = mot.rotationEuler{pairs{i}(1)};
end

newmot.rotationEuler{1}(2,:) = -newmot.rotationEuler{1}(2,:);
newmot.rotationEuler{1}(3,:) = -newmot.rotationEuler{1}(3,:);

for i=2:mot.njoints
    idx = strmatch('ry', lower(skel.nodes(i).DOF), 'exact');
    if ~isempty(idx)
        newmot.rotationEuler{i}(idx,:) = -newmot.rotationEuler{i}(idx,:);
    end
    idx = strmatch('rz', lower(skel.nodes(i).DOF), 'exact');
    if ~isempty(idx)
        newmot.rotationEuler{i}(idx,:) = -newmot.rotationEuler{i}(idx,:);
    end
end

newmot                      = C_convert2quat(newskel,newmot);
newmot.jointTrajectories    = iterativeForwKinematics(newskel,newmot);
newmot.boundingBox          = computeBoundingBox(newmot);