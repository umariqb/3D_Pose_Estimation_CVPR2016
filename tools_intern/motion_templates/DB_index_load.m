function varargout = DB_index_load(DB_name,feature_set,downsampling_fac)
% [DB_concat,indexArray] = DB_index_load(DB_name,feature_set,downsampling_fac)

global VARS_GLOBAL

load_index = false;
if (nargout>1)
    load_index = true;
end

if (iscell(feature_set))
    feature_set_name = '';
    for i=1:length(feature_set)
        if (i==1)
            feature_set_name = feature_set{i};
        else
            feature_set_name = [feature_set_name '_' feature_set{i}];
        end
    end
else
    feature_set_name = feature_set;
end     

sampling_rate_string = num2str(120/downsampling_fac);

load DB_info;
DB_names = {DB_info.DB_name}';
I = strmatch(DB_name,DB_names,'exact');
if (isempty(I))
    error('Unknown DB name!');
end

if (iscell(feature_set))
    for k=1:length(feature_set)
        load(fullfile(VARS_GLOBAL.dir_root_retrieval,DB_info(I).index_path,['index_' feature_set{k} '_' DB_name '_' sampling_rate_string '.mat']));
        indexArray(k) = index;
    end
else
    load(fullfile(VARS_GLOBAL.dir_root_retrieval,DB_info(I).index_path,['index_' feature_set '_' DB_name '_' sampling_rate_string '.mat']));
    indexArray = index;
end
DB_concat = features_load_concat(fullfile(VARS_GLOBAL.dir_root_retrieval,DB_info(I).DB_concat_path,['DB_concat_' feature_set_name '_' DB_name '_' sampling_rate_string '.mat']));

varargout{1} = DB_concat;
if (nargout>1)
    varargout{2} = indexArray;
end
