function DB_features = features_concatenate(features, filenames, varargin)

use_NAN_padding = false;
num_NAN_columns = 0;
filename = '';
if (nargin>3)
    filename = varargin{2};    
end
if (nargin>2)
    num_NAN_columns = varargin{1};
    use_NAN_padding = num_NAN_columns>0;    
end

nfiles = length(features);
nfeatures = size(features{1},1);
nframes = 0;
DB_features.files_frame_start = zeros(1,nfiles);
DB_features.files_frame_end = zeros(1,nfiles);
DB_features.files_frame_length = zeros(1,nfiles);
DB_features.files_name = filenames;
for k=1:nfiles
    DB_features.files_frame_start(k) = nframes + 1;
    nframes = nframes + size(features{k},2);
    DB_features.files_frame_end(k) = nframes;
    DB_features.files_frame_length(k) = size(features{k},2);
end

if (use_NAN_padding)
    DB_features.files_frame_start = DB_features.files_frame_start + num_NAN_columns*[0:nfiles-1];
    DB_features.files_frame_end = DB_features.files_frame_end + num_NAN_columns*[0:nfiles-1];
    DB_features.features = zeros(nfeatures,nframes+num_NAN_columns*nfiles);
    for k=1:nfiles
        DB_features.features(:,DB_features.files_frame_start(k):DB_features.files_frame_end(k)) = features{k};
        DB_features.features(:,DB_features.files_frame_end(k)+[1:num_NAN_columns]) = NaN*ones(nfeatures,num_NAN_columns);
    end
else
    DB_features.features = zeros(nfeatures,nframes);
    for k=1:nfiles
        DB_features.features(:,DB_features.files_frame_start(k):DB_features.files_frame_end(k)) = features{k};
    end
end

if (~isempty(filename)) % save result to MAT file
    DB_save = DB_features;
    if (use_NAN_padding)
        DB_save.features(isnan(DB_save.features)) = 255;
    end
    DB_save.features = char(DB_save.features);
    save(filename,'DB_save');
end
    