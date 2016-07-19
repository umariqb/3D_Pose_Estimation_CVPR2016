% function addDOFIDsToSkel
% adds struct "DOFIDs" to each node of denoted skel with indices
% identifying its respective (rotational) dofs (->efficiency)
% x -> 1, y -> 2, z -> 3
% example:
% skel = addDOFIDsToSkel(skel)
% author: Jochen Tautges, tautges@cs.uni-bonn.de

function skel = addDOFIDsToSkel(skel)

for i=1:skel.njoints
    skel.nodes(i).DOFIDs = [];
    for j=1:size(skel.nodes(i).DOF,1)
        dof = lower(skel.nodes(i).DOF{j});
        if strcmp(dof(1),'r');
            skel.nodes(i).DOFIDs = [skel.nodes(i).DOFIDs ...
                strfind(lower(skel.nodes(i).rotationOrder),dof(2))];
        end
    end
end