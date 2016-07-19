function [positions, derivatives] = recursive_fK_Quat_frame(node_id, rotationQuat, nodes, current_position, current_derivative, current_rotation, positions, derivatives)

positions{node_id,1} = current_position;
derivatives{node_id,1} = current_derivative;


for child_id = nodes(node_id).children' 
    child = nodes(child_id);
	
    % ------------ symbolic calculations start ---------------
	syms child_position child_rotation child_offset child_offset_x child_offset_y child_offset_z
	syms current_pos current_pos_x current_pos_y current_pos_z
	syms w1 w2 x1 x2 y1 y2 z1 z2
	
	child_offset = [child_offset_x; child_offset_y; child_offset_z];
	current_pos = [current_pos_x; current_pos_y; current_pos_z];
	
	child_rotation = quatmult( [w1;x1; y1; z1], [w2; x2; y2; z2]);
	child_position = current_position + quatrot(child_offset, child_rotation);
	child_position_diff = diff(child_position);
	
	% assign values
    if isempty(current_rotation)
        current_rotation = [1;0;0;0];
    end
    if isempty(rotationQuat{child_id})
        rotationQuat{child_id} = [1;0;0;0];
    end
    w1 = current_rotation(1);
    x1 = current_rotation(2);
    y1 = current_rotation(3);
    z1 = current_rotation(4);
	w2 = rotationQuat{child_id}(1);
	x2 = rotationQuat{child_id}(2);
	y2 = rotationQuat{child_id}(3);
	z2 = rotationQuat{child_id}(4);
    child_offset_x = child.offset(1);
    child_offset_y = child.offset(2);
    child_offset_z = child.offset(3);
    current_pos_x = current_position(1);
    current_pos_y = current_position(2);
    current_pos_z = current_position(3);
    child_position = eval(child_position);
    child_derivative = eval(child_position_diff);
    child_rotation = eval(child_rotation);
	
	% ------------ symbolic calculations end ---------------

    
%     if (~isempty(rotationQuat{child_id}))
%         child_rotation = quatmult(current_rotation, rotationQuat{child_id});
%     else
%         child_rotation = current_rotation;
%     end
% 
%     child_position = current_position + quatrot( child.offset, child_rotation );

    [positions, derivatives] = recursive_fK_Quat_frame(child_id, rotationQuat, nodes, child_position, child_derivative, child_rotation, positions, derivatives);
end