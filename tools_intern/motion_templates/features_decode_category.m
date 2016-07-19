function [features, filenames, feature_set_ranges] = features_decode_category(basedir_features,category,feature_set,varargin)
% features, filenames] = features_decode_category(basedir_features,category,feature_set,fileranges,downsampling_fac,basedir_MC)

global VARS_GLOBAL

fileranges = {};
downsampling_fac = 1;
basedir_MC = basedir_features;
if (nargin>5)
    basedir_MC = varargin{3};
end
if (nargin>4)
    downsampling_fac = varargin{2};
end
if (nargin>3)
    fileranges = varargin{1};
    if (~iscell(fileranges))
        fileranges = {fileranges};
    end
end

if (isempty(category)) % in this case, use ALL categories in basedir_MC
    d = dir(fullfile(VARS_GLOBAL.dir_root, basedir_MC, ''));
    isdir = [d.isdir];
    d = d(find(isdir));
    c = {d.name}';
    num_category = 0;
    category = cell(length(c),1);
    for k=1:length(c)
        if (c{k}(1)~='_' & ~strcmp(c{k},'.') & ~strcmp(c{k},'..')) % exclude dirnames beginning with an underscore
            num_category = num_category+1;
            category{num_category} = c{k};
        end
    end
    category = category(1:num_category);
end

if (~iscell(category))
    category = {category};
end

if (~iscell(feature_set))
    feature_set = {feature_set};
end

feature_set_ranges = cell(length(feature_set),1);
filenames = {};
features = {};
nfiles_processed = 0;
for j=1:length(category)
    for f=1:length(feature_set)
        fullpath = fullfile(VARS_GLOBAL.dir_root_retrieval,basedir_features,feature_set{f},['F_' feature_set{f} '_' category{j} '.mat']);
        fid = fopen(fullpath);
        if (fid ~= -1)
            fclose(fid);
            load(fullpath);
        else
            continue;
        end
        
        if (length(fileranges)>=j)
            filerange = fileranges{j};
            if (~isempty(filerange))
                h = intersect(filerange,[1:length(F.files)]);
                if (length(h)<length(filerange))
%                    warning('Invalid file range! I will only consider files that actually exist.');
                    filerange = h;
                end
            else
                filerange = [1:length(F.files)];
            end
        else
            filerange = [1:length(F.files)];
        end
        
        nfiles = length(filerange);
        for k=1:nfiles
            if (f==1) % insert the features for feature_set{1}
                if (downsampling_fac > 1)
                    features_new = features_decode_single_file(F,filerange(k));
                    features_new = features_new(:,1:downsampling_fac:end);
                    features{k+nfiles_processed,1} = features_new;
                else
                    features{k+nfiles_processed,1} = features_decode_single_file(F,filerange(k));
                end
                if (j==1 & k==1) % only determine feature set ranges once
                    feature_set_ranges{1} = 1:size(features{k+nfiles_processed,1},1);
                end
                filenames{k+nfiles_processed,1} = F.files{filerange(k)};
            else % append the features for feature_set{2}...feature_set{m}
                if (downsampling_fac > 1)
                    features_new = features_decode_single_file(F,filerange(k));
                    features_new = features_new(:,1:downsampling_fac:end);
                    features{k+nfiles_processed,1} = [features{k+nfiles_processed,1}; features_new];
                else
                    features_new = features_decode_single_file(F,filerange(k));
                    features{k+nfiles_processed,1} = [features{k+nfiles_processed,1}; features_new];
                end
                if (j==1 & k==1) % only determine feature set ranges once
                    feature_set_ranges{f} = feature_set_ranges{f-1}(end)+1:(feature_set_ranges{f-1}(end) + size(features_new,1));
                end
            end
        end
        if (f==length(feature_set)) % only count files once, not length(feature_set) times
            nfiles_processed = nfiles_processed + nfiles;
        end
    end
end


