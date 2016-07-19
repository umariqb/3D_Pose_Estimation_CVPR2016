function trajectories = recursive_forwardKinematicsQuat(skel, mot, node_id, current_position, current_rotation, trajectories)
% trajectories = recursive_forwardKinematicsQuat(skel, mot, node_id, current_position, current_rotation, trajectories)
%
% skel:                 skeleton
% mot:                  motion
% node_id:              index of current node in node array
% current_position:     for all frames: current local coordinate offsets from world origin (3xnframes sequence of vectors)
% current_rotation:     for all frames: current local coordinate rotations against world coordinate frame (4xnframes sequence of quaternions)
% trajectories:         input & output cell array containing the trajectories that have been computed so far

trajectories{node_id,1} = current_position;

for child_id = skel.nodes(node_id).children'
    child = skel.nodes(child_id);

    if (~isempty(mot.rotationQuat{child_id}))
        child_rotation = quatmult(current_rotation,mot.rotationQuat{child_id});
    else
        child_rotation = current_rotation;
    end

    child_position = current_position + quatrot(repmat(child.offset,1,mot.nframes),child_rotation);

    trajectories = recursive_forwardKinematicsQuat(skel, mot, child_id, child_position, child_rotation, trajectories);
end