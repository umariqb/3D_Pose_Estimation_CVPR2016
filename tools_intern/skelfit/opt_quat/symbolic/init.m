syms child_position child_rotation child_offset child_offset_x child_offset_y child_offset_z
syms current_position current_position_x current_position_y current_position_z
syms w1 w2 x1 x2 y1 y2 z1 z2

child_offset = [child_offset_x; child_offset_y; child_offset_z];
current_position = [current_position_x; current_position_y; current_position_z];

child_rotation = quatmult( [w1;x1; y1; z1], [w2; x2; y2; z2]);
child_position = current_position + quatrot(child_offset, child_rotation);

