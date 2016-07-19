function [positions, quats] = recursive_fK_Quat_frame(node_id, rotationQuat, nodes, current_position, current_rotation, positions, quats)

positions{node_id,1} = current_position;
quats{node_id,1} = current_rotation;

for child_id = nodes(node_id).children'
    child = nodes(child_id);

    if (~isempty(rotationQuat{child_id}))
        child_rotation = quatmult(current_rotation, rotationQuat{child_id});
    else
        child_rotation = current_rotation;
    end

    child_position = current_position + quatrot( child.offset, child_rotation );

    [positions, quats] = recursive_fK_Quat_frame(child_id, rotationQuat, nodes, child_position, child_rotation, positions, quats);
end