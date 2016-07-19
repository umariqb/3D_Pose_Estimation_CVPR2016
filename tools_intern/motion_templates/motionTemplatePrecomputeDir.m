function y = motionTemplatePrecomputeDir(directory,parameter,outpath,varargin)
% y = motionTemplatePrecomputeDir(directory,parameter,outpath,motions_to_use_num,rel)
%
% rel.... boolean flag. if rel==true, motions_to_use is expected to be a factor between 
%         0 and 1 specifying the percentage of files in a category to be used for template 
%         training.

global VARS_GLOBAL

parameter.visStatistics      = 0;
parameter.visCost            = 0;
parameter.visWarp            = 0;
parameter.visTemplate        = 0;
parameter.visVrepW           = 0;
parameter.visIterations      = 0;
parameter.visLastIteration   = 0;

suffix = parameter.filename_suffix;

parameter.basedir = directory;
if ~isfield(parameter,'category') % if category is not specified, last path component of basedir will be interpreted as category
    b = parameter.basedir;
    while (b(end)==filesep)
        b = b(1:end-1);
    end
    I = findstr(b,filesep);
    if not(isempty(I))
        parameter.category = b(I(end)+1:end);
        parameter.basedir = [b(1:I(end)) filesep '_features'];
    end
end

%%%%%%% find out how many motions are available in this directory
% files = dir([VARS_GLOBAL.dir_root filesep directory filesep '*.amc']); 
files = [ dir([VARS_GLOBAL.dir_root filesep directory filesep '*.amc']);
          dir([VARS_GLOBAL.dir_root filesep directory filesep '*.c3d']) ];
files_num = length(files);
if (files_num<=1)
    y = [];
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% files_names = {files.name}';
% for k=1:files_num
%     files_info(k) = filename2info(files_names{k});
% end
%%%%%%% Extract motionCategory from first file name. 
%%%%%%% This assumes that all files belong to the same category.
files_info = filename2info(files(1).name);
motionCategory = files_info.motionCategory;
%%%%%%%%%%%%%%

%%%%%% select motions that should be used in the template computation
if (nargin>3) % motions_to_use_num specified
    rel = false;
    if (nargin>4)
        rel = varargin{2};
    end
    if (rel)
        motions_to_use_num = max(2,min(files_num,ceil(files_num*varargin{1})));
    else
        motions_to_use_num = max(2,min(files_num,varargin{1}));
    end
    %%% spread motions_to_use_num numbers evenly in the range 1:files_num
    parameter.files = floor([0:motions_to_use_num-1]*files_num/motions_to_use_num) + 1;
else % use all
    parameter.files = [1:files_num];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% prepare file name
feature_set = parameter.feature_set;
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
outfile = ['template_' motionCategory '_' feature_set_name '_' num2str(length(parameter.files)) 'of' num2str(files_num) '_' num2str(120/parameter.downsampling_fac) suffix '.mat'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% compute motion template
motionTemplateGenerateDTWIterative(parameter,outpath,outfile);
y = files;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%