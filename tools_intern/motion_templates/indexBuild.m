function index = indexBuild(basedir_features,category,feature_set,files,varargin)

downsampling_fac = 1;
if (nargin>4)
    basedir_MC = varargin{2};
end
if (nargin>3)
    downsampling_fac = varargin{1};
end

global VARS_GLOBAL

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

F_filenames = cell(length(category),1);
for k=1:length(category)
    F_filenames{k} = fullfile(VARS_GLOBAL.dir_root_retrieval,basedir_features,feature_set,['F_' feature_set '_' category{k} '.mat']);
end

F = features_matfiles_concat(F_filenames,files);
index = index_build(F,[],downsampling_fac,false);
