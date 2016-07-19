function index = index_build(F,varargin)

features_select = [1:length(F.features_spec)];
downsampling_fac = 1;
use_lists_complete = false;
if (nargin>3)
    use_lists_complete = varargin{3};
end
if (nargin>2)
    downsampling_fac = varargin{2};
end
if (nargin>1)
    if (~isempty(varargin{1}))
        features_select = varargin{1};
    end
end

features_num = length(features_select);
files_num = length(F.files);

lists_num = 2^features_num;

index = index_struct;
index.files = F.files;
index.files_num = files_num;
index.files_sampling_rate = F.files_sampling_rate;
index.files_frame_length = zeros(1,files_num);
index.features_spec = F.features_spec(features_select);
index.features_num = length(index.features_spec);
if (~use_lists_complete)
    index.segments = repmat(index.segments,files_num,1);
else
    index.lists_complete = cell(lists_num,1);
end
index.files_segment_length = zeros(1,files_num);
index.lists = cell(lists_num,1);
index.lists_num = lists_num;
index.lists_length = zeros(lists_num,1);

for file_id = 1:files_num
    features_binary = features_decode_single_file(F,file_id);
    features_binary = features_binary(:,1:downsampling_fac:end);
    frames_num = size(features_binary,2);
    index.files_frame_length(file_id) = frames_num;
    pows2 = repmat((2.^[0:features_num-1])',1,frames_num);
    features = sum(features_binary(features_select,:).*pows2,1) + 1;
    [runs,runs_start,runs_length] = runs_find_constant(features);
    
    if (~use_lists_complete)
        index.segments(file_id).features = runs;
        index.segments(file_id).frames_start = runs_start;
        index.segments(file_id).frames_length = runs_length;
    end
    index.files_segment_length(file_id) = length(runs);
    
    for k=1:length(runs)
        if (isempty(index.lists{runs(k)}))
            index.lists{runs(k)} = [file_id; k];
            if (use_lists_complete)
                index.lists_complete{runs(k)} = [file_id; k; runs_start(k); runs_length(k)];
            end
        else
            index.lists{runs(k)} = [index.lists{runs(k)} [file_id; k]];
            if (use_lists_complete)
                index.lists_complete{runs(k)} = [index.lists_complete{runs(k)} [file_id; k; runs_start(k); runs_length(k)]];
            end
        end
    end
end

for k=1:lists_num
    index.lists_length(k) = size(index.lists{k},2);
end