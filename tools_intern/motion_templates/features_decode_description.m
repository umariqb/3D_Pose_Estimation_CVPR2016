function [features, filenames, feature_set_ranges] = features_decode_description(basedir_features,category,feature_set,description,varargin)

global VARS_GLOBAL

downsampling_fac = 1;
if (nargin>4)
    downsampling_fac = varargin{1};
end

if (~iscell(description))
    description = {description};
end

if (~iscell(feature_set))
    feature_set = {feature_set};
end

feature_set_ranges = cell(length(feature_set),1);
filenames = {};
features = {};
nfiles_processed = 0;
for j=1:length(description)
    for f=1:length(feature_set)
        fullpath = fullfile(VARS_GLOBAL.dir_root,basedir_features,feature_set{f},['F_' feature_set{f} '_' category '.mat']);
        fid = fopen(fullpath);
        if (fid ~= -1)
            fclose(fid);
            load(fullpath);
        else
            continue;
        end
        
        info = repmat(filename2info(F.files{1}),length(F.files),1);
        for i=2:length(F.files)
            info(i) = filename2info(F.files{i});
        end
        motionCategories = {info.motionCategory}';
        filerange = strmatch(description{j},motionCategories);
        nfiles = length(filerange);
        
        for k=1:nfiles
            if (f==1) % insert the features for feature_set{1}
                if (downsampling_fac > 1)
                    features_downsampled = features_decode_single_file(F,filerange(k));
                    features_downsampled = features_downsampled(:,1:downsampling_fac:end);
                    features{k+nfiles_processed,1} = features_downsampled;
                else
                    features{k+nfiles_processed,1} = features_decode_single_file(F,filerange(k));
                end
                if (j==1 & k==1) % only determine feature set ranges once
                    feature_set_ranges{1} = 1:size(features{k+nfiles_processed,1},1);
                end
                filenames{k+nfiles_processed,1} = F.files{filerange(k)};
            else % append the features for feature_set{2}...feature_set{m}
                if (downsampling_fac > 1)
                    features_downsampled = features_decode_single_file(F,filerange(k));
                    features_downsampled = features_downsampled(:,1:downsampling_fac:end);
                    features{k+nfiles_processed,1} = [features{k+nfiles_processed,1}; features_downsampled];
                else
                    features{k+nfiles_processed,1} = [features{k+nfiles_processed,1}; features_decode_single_file(F,filerange(k))];
                end
                if (j==1 & k==1) % only determine feature set ranges once
                    feature_set_ranges{f} = feature_set_ranges{f-1}(end)+1:feature_set_ranges{f-1}(end) + size(features{k+nfiles_processed,1},1);
                end
            end
        end
        if (f==length(feature_set)) % only count files once, not length(feature_set) times
            nfiles_processed = nfiles_processed + nfiles;
        end
    end
end
