global VARS_GLOBAL

downsampling_fac = 4;
sampling_rate_string = num2str(120/downsampling_fac);

% DB_names = {'HDM_MCH'};
%DB_names = {'MediumDB'};
%DB_names  = {'cut_amc'}
% DB_names = {'HDM05_amc', 'HDM05_c3d'};
% DB_names = {'TestDB_c3d'};
%DB_names = {'HDM_Uncut'};
%DB_names = {'HDM_MCT','HDM_MCE'};
%DB_names = {'HDM_MCE'};
%DB_names = {'HDM_MCE_BD_walkRight'};
%DB_names = {'HDM_MC'};
%DB_names = {'HDM_MCT'};
%DB_names = {'HDM_MC_BD','HDM_MCT_BD','HDM_MCE_BD'};
%DB_names = ''; 
%do all
% feature_sets = {'AK_upper','AK_lower','AK_mix', {'AK_upper','AK_lower'}, {'AK_upper','AK_mix'}, {'AK_lower','AK_mix'}, {'AK_upper','AK_lower','AK_mix'}};
feature_sets = { 'AK_upper', 'AK_lower', 'AK_mix_avr', {'AK_upper','AK_lower'}, {'AK_upper','AK_mix_avr'}, {'AK_lower','AK_mix_avr'}, {'AK_upper','AK_lower','AK_mix_avr'}};
%feature_sets = {'AK_mix'};
% feature_sets = VARS_GLOBAL.feature_sets;

DB_names=VARS_GLOBAL.DB;

load DB_info;
if (~isempty(DB_names))
    all_DB_names = {DB_info.DB_name};
    [x,IA,IB] = intersect(DB_names,all_DB_names);
    if (isempty(IB))
        error('Unknown DB names!');
    end
    DB_info = DB_info(IB);
end


% generate indexes, load and concatenate features %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:length(DB_info)
    
    oldPath = cd;
    
    cd(VARS_GLOBAL.dir_root_retrieval);
    
    if ~exist(DB_info(j).DB_name)
        mkdir(DB_info(j).DB_name);
    end
    
    cd(DB_info(j).DB_name);
    if ~exist('_DB_concat')
        mkdir('_DB_concat');
        cd('_DB_concat');
        fclose(fopen('skip','w'));  % create skip file
        cd('..');
    end
    if ~exist('_indexes')
        mkdir('_indexes');
        cd('_indexes');
        fclose(fopen('skip','w'));  % create skip file
        cd('..');
        end
    
    cd(oldPath);
    
    for k=1:length(feature_sets)
        feature_set = feature_sets{k};
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
        
        DB_name = DB_info(j).DB_name;
        DB_path = DB_info(j).DB_path;
        category = DB_info(j).category;
        files = DB_info(j).files;
        features_path = DB_info(j).features_path;
        DB_concat_path = DB_info(j).DB_concat_path;
        disp(['Computing DB_concat for DB ' DB_name ', feature_set = ' feature_set_name '.']);
        
        [DB_all,filenames_all] = features_decode_category(features_path,category,feature_set,files,downsampling_fac,DB_path);
        features_concatenate(DB_all,filenames_all,2,fullfile(VARS_GLOBAL.dir_root_retrieval,DB_concat_path,['DB_concat_' feature_set_name '_' DB_name '_' sampling_rate_string '.mat']));
        clear DB_all; clear filenames_all;
        
        if (~iscell(feature_set))
            disp(['Computing index for DB ' DB_name ', feature_set = ' feature_set_name '.']);
            index = indexBuild(features_path,category,feature_set,files,downsampling_fac,DB_path);
            save(fullfile(VARS_GLOBAL.dir_root_retrieval,DB_info(j).index_path,['index_' feature_set '_' DB_name '_' sampling_rate_string '.mat']),'index');
        end
    end
end
