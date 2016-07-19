global VARS_GLOBAL

close all;

basedir = VARS_GLOBAL.DB;
%files = [1:14];
% category = 'walk2StepsLstart';
% category = 'rotateArmsLForward1Reps';     % all
category = '';
% , 'elbowToKnee1RepsLelbowStart',
% 'walkBackwards2StepsRstart','kickLFront1Reps' };
%category = 'jogLeftCircle4StepsRstart';
%category = 'cartwheelLHandStart1Reps';
parameter = [];

parameter.visVrepW           = 0;
parameter.visTemplateFinal   = 0;
parameter.downsampling_fac   = 4;
parameter.VrepWoverlapFactor = 0; % parameter.VrepWoverlapFactor = 0 yields same behavior as "classical" connected components approach
parameter.iter_max           = 10;
parameter.iter_thresh        = 0.000;
parameter.iter_thresh        = 0.0;


% 5:    Normal template computation strategy:
% 6:    This affects the averaging step. 0nly identical values are
%       kept in the averaging step and all differing values are set to
%       0.5.
%       Use expansion and contraction operators after each iteration.
% 7:    do not use weights in matching
%       Averaging step: only keep identical values. 
% 8:    use weights in matching
%       Averaging step: only keep identical values.
%       Apply the uniqueness operator prior to every iteratoin.
%       Don't apply expansion and contracion operators afterwards.
%       Kontraktions-Templates

parameter.templateComputationStrategy = 6;
parameter.conjoin            = 0;
parameter.filename_suffix    = '';
%percentage = 1;
percentage = 0.5;

% the feature-sets defined in VAR_GLOBALS have to be enclosed in Cells.
% All combinations of feature sets will be computed to have a maximum of
% flexibility.
% parameter.feature_set={'AK_lower'};
parameter.feature_set=VARS_GLOBAL.feature_sets;
%subsets_all(VARS_GLOBAL.feature_sets, 3);
%parameter.feature_set={'AK_lower_AK_upper_AK_mix'};
       

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
    
    feature_set_name = concatStringsInCell(feature_set);
    
       
    overlap_factor_str = num2str(floor(100*p.VrepWoverlapFactor));

    outpath = [filesep, 'templates_', feature_set_name, '_', num2str(p.templateComputationStrategy), '_',...
                        overlap_factor_str, '_', num2str(120/p.downsampling_fac) parameter.filename_suffix];
                    
    d = dir([outpath_prefix filesep outpath]);               
    if (isempty(d))
        mkdir(outpath_prefix,outpath);
    end
    y = forAllDirsInDirRelPaths(fullfile(VARS_GLOBAL.dir_root, basedir, category, ''),@motionTemplatePrecomputeDir,true,{},p,[outpath_prefix outpath],percentage,true);
end
