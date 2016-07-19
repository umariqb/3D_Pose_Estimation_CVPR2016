function hold_frames_sequence = videoRangesToHoldFramesSequence(range_and_pad_info,downsampling_fac)

num_ranges = size(range_and_pad_info,2);
hold_frames_sequence = cell(1,num_ranges);

num_frames_total = 0;
for k=1:num_ranges
    range_downsampled = intersect(range_and_pad_info{1,k},[1:downsampling_fac:range_and_pad_info{1,k}(end)+downsampling_fac]);
    num_frames = length(range_downsampled);
    prepad = range_and_pad_info{2,k};
    postpad = range_and_pad_info{3,k};
    num_frames_total = num_frames_total + prepad + num_frames + postpad;
end

num_frames_output = 0;
for k=1:num_ranges
    range_downsampled = intersect(range_and_pad_info{1,k},[1:downsampling_fac:range_and_pad_info{1,k}(end)+downsampling_fac]);
    num_frames = length(range_downsampled);
    prepad = 0;
    postpad = 0;
    prepad = range_and_pad_info{2,k};
    postpad = range_and_pad_info{3,k};
    
    hold_frames_sequence{k} = ones(1,num_frames);
    num_frames_output = num_frames_output + prepad;
    hold_frames_sequence{k}(1) =  num_frames_output + 1;
    num_frames_output = num_frames_output + num_frames;
    hold_frames_sequence{k}(end) = num_frames_total - num_frames_output + 1;
    num_frames_output = num_frames_output + postpad;
end
