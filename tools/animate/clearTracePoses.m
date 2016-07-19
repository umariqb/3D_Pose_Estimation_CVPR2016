function clearTracePoses
global VARS_GLOBAL_ANIM
if (isempty(VARS_GLOBAL_ANIM)||isempty(VARS_GLOBAL_ANIM.graphics_data))
    return;
end

f = find(cell2mat({VARS_GLOBAL_ANIM.graphics_data.figure}) == gcf);
if (isempty(f))
    return;
end
VARS_GLOBAL_ANIM.graphics_data_index = f;

num_trace_poses = size(VARS_GLOBAL_ANIM.graphics_data(f).trace_poses,2);
num_lines_per_pose = size(VARS_GLOBAL_ANIM.graphics_data(f).trace_poses,1);
for k=1:num_trace_poses
    for j=1:num_lines_per_pose
        delete(VARS_GLOBAL_ANIM.graphics_data(f).trace_poses{j,k}(ishandle(VARS_GLOBAL_ANIM.graphics_data(f).trace_poses{j,k})));
    end
end
VARS_GLOBAL_ANIM.graphics_data(f).trace_poses = {};