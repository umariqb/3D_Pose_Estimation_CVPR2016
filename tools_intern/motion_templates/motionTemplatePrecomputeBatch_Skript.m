function error=motionTemplatePrecomputeBatch_Skript(featureSET)

global VARS_GLOBAL

close all;
basedir = 'cut_amc'
% basedir = 'HDM05_cut_amc';
%  basedir = 'HDM05_cut_c3d';
% basedir = 'TestDB_amc';
% basedir = 'TestDB_c3d';
%files = [1:14];
% category = 'walkRightCircle4StepsLstart';
category = '';     % all

parameter = [];

parameter.visVrepW           = 0;
parameter.visTemplateFinal   = 0;
parameter.downsampling_fac   = 4;
parameter.VrepWoverlapFactor = 0; % parameter.VrepWoverlapFactor = 0 yields same behavior as "classical" connected components approach
parameter.iter_max           = 10;
parameter.iter_thresh        = 0.005;
parameter.templateComputationStrategy = 5;
parameter.conjoin            = 0;
%parameter.filename_suffix    = '_all_training';
parameter.filename_suffix    = '';
%percentage = 1;
percentage = 0.5;

% parameter.feature_set = {{'AK_upper','AK_lower','AK_mix'}};
parameter.feature_set = featureSET;
%parameter.feature_set = {'AK_mix'};

% parameter.feature_set = {{'AK_upper','AK_lower','AK_mix'},...
%                         {'AK_upper','AK_lower'},...
%                         {'AK_upper','AK_mix'},...
%                         {'AK_lower','AK_mix'},...
%                         {'AK_upper'},...
%                         {'AK_lower'},...
%                         {'AK_mix'},...
%                         };

% parameter.feature_set = {{'AK_upper','AK_lower','AK_mix'},...
%                          {'AK_upper','AK_lower'},...
%                          {'AK_upper','AK_mix'},...
%                           'AK_upper'};

%  parameter.feature_set = {{'AK_upper','AK_lower','AK_mix'},...
%                           {'AK_upper','AK_mix'},...
%                           {'AK_lower','AK_mix'},...
%                           'AK_mix'};
                 

outpath_prefix = fullfile(VARS_GLOBAL.dir_root_retrieval, basedir, '_templates','');

oldPath = cd;
cd(VARS_GLOBAL.dir_root_retrieval);
if ~exist(basedir)
    mkdir(basedir);
end
cd(basedir);
if ~exist('_templates')
    mkdir('_templates');
    cd('_templates');
    fclose(fopen('skip','w'));  % create skip file
    cd('..');
end
cd(oldPath);

p = parameter;
for j=1:length(parameter.feature_set)
    p.feature_set = parameter.feature_set{j};
    feature_set = p.feature_set;
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
    
    overlap_factor_str = num2str(floor(100*p.VrepWoverlapFactor));

    outpath = [filesep, 'templates_', feature_set_name, '_', num2str(p.templateComputationStrategy), '_',...
                        overlap_factor_str, '_', num2str(120/p.downsampling_fac) parameter.filename_suffix];
                    
    d = dir([outpath_prefix filesep outpath]);               
    if (isempty(d))
        mkdir(outpath_prefix,outpath);
    end
    y = forAllDirsInDirRelPaths(fullfile(VARS_GLOBAL.dir_root, basedir, category, ''),@motionTemplatePrecomputeDir,true,{},p,[outpath_prefix outpath],percentage,true);
end
error=0;
