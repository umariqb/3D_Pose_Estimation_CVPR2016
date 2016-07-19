function varargout = motionTemplateLoadMatfile(basedir_templates,category,feature_set,settings)
% [motionTemplate,motionTemplateWeights,motionTemplateKeyframes,parameter,statistics] = motionTemplateLoadMatfile(basedir,category,feature_set,settings)

global VARS_GLOBAL

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

% pth = fullfile('/data/HDM/HDM05_boolFeature/', basedir_templates, ['templates_' feature_set_name '_' settings],'');
pth = fullfile(VARS_GLOBAL.dir_root_retrieval, basedir_templates, ['templates_' feature_set_name '_' settings],'');
flnm = ['template_' category '_' feature_set_name '*.mat'];

d = dir(fullfile(pth,flnm));

if (~isempty(d))
    load(fullfile(pth,d.name));
    
    varargout{1} = motionTemplate;
    varargout{2} = motionTemplateWeights;
    varargout{3} = motionTemplateKeyframes;
    varargout{4} = parameter;
%    varargout{5} = statistics;
else
    varargout{1} = [];
    varargout{2} = [];
    varargout{3} = [];
    varargout{4} = [];
%    varargout{5} = [];
end