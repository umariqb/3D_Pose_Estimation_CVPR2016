function hold_frames = videoRangesToHoldFrames(range_info,downsampling_fac)

num_ranges = size(range_info,2);
hold_frames = cell(1,num_ranges);

num_frames_max = 0;
for k=1:num_ranges
    range_downsampled = intersect(range_info{k},[1:downsampling_fac:range_info{k}(end)+downsampling_fac]);
    num_frames = length(range_downsampled);
    num_frames_max = max(num_frames_max,num_frames);
end

for k=1:num_ranges
    range_downsampled = intersect(range_info{k},[1:downsampling_fac:range_info{k}(end)+downsampling_fac]);
    num_frames = length(range_downsampled);
    num_frames_missing = num_frames_max - num_frames;
    prepad = floor(num_frames_missing/2);
    postpad = ceil(num_frames_missing/2);
    
    hold_frames{k} = ones(1,num_frames);
    hold_frames{k}(1) =  prepad + 1;
    hold_frames{k}(end) = postpad + 1;
end
