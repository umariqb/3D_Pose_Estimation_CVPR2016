function [localRotations] = recursive_getLocalSystems(skel, mot, node_id, current_rotation, localRotations)

localRotations{node_id,1} = current_rotation;

for child_id = skel.nodes(node_id).children'
    if (~isempty(mot.rotationQuat{child_id}))
        child_rotation = quatmult(current_rotation,mot.rotationQuat{child_id});
    else
        child_rotation = current_rotation;
    end
    [localRotations] = recursive_getLocalSystems(skel, mot, child_id, child_rotation, localRotations);
end