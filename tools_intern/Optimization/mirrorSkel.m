% function mirrorSkel
% mirrors specified skeleton on the yz-plane
% newskel = mirrorSkel(skel)
% author: Jochen Tautges (tautges@cs.uni-bonn.de)

function newskel=mirrorSkel(skel)

newskel     = skel;
newskel.filename = [skel.filename '.mirrored'];

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
    newskel.nodes(pairs{i}(1)).length = skel.nodes(pairs{i}(2)).length;
    newskel.nodes(pairs{i}(2)).length = skel.nodes(pairs{i}(1)).length;
    
    newskel.nodes(pairs{i}(1)).offset = skel.nodes(pairs{i}(2)).offset;
    newskel.nodes(pairs{i}(2)).offset = skel.nodes(pairs{i}(1)).offset;
    
    newskel.nodes(pairs{i}(1)).direction = skel.nodes(pairs{i}(2)).direction;
    newskel.nodes(pairs{i}(2)).direction = skel.nodes(pairs{i}(1)).direction;
    
    newskel.nodes(pairs{i}(1)).axis = -skel.nodes(pairs{i}(2)).axis;
    newskel.nodes(pairs{i}(2)).axis = -skel.nodes(pairs{i}(1)).axis;
end

for i=1:skel.njoints
    newskel.nodes(i).offset(1)      = -newskel.nodes(i).offset(1);
    newskel.nodes(i).direction(1)   = -newskel.nodes(i).direction(1);
    newskel.nodes(i).axis(1)        = -newskel.nodes(i).axis(1);
end