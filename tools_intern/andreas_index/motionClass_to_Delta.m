function [hits,C,D,delta, classificationDelta] = motionClass_to_Delta(motionClass, databaseFeatures, basedir_templates, feature_set, parameter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: motionClass_to_Delta
% Version: 1
% Date: 06.08.2008
% Programmer: Andreas Baak
%
% Description: 
%
% Input:  
%         motionClass: A cell array of strings. Each string describes a
%         motion class. The delta curves of all described motion classes
%         will be minimized.
%         basedir_templates: directory where the motion templates reside.
%         features_set: the feature set of the motion templates
%
%         parameter.thresh_quantize_mt = 0.1         
%         parameter.hit_threshold = 0.1
%         parameter.di:                 step size condition
%         parameter.dj :                step size condition
%         parameter.dWeights:           step size condition
%         parameter.match_endExclusionForward = 0.0;
%         parameter.match_endExclusionBackward = 0.5;
%         parameter.match_startExclusionForward = 0.5;
%         parameter.match_startExclusionBackward = 0.0;
%         parameter.expandV = 1;   
%         parameter.outputC = 0;
%         parameter.outputD = 0;
%         parameter.outputHits = 0;
%         parameter.outputDelta = 0;
%         parameter.outputClassificationDelta = 0;
%         parameter.match_numMax = 100;
%         parameter.vis = 0;

%         
%
% Output: 
%         hits
%         C
%         D
%         delta
%         classificationDelta
%         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<5
   parameter=[]; 
end

if nargin<4
   error('Please specify input data');
end


if isfield(parameter,'ranges')==0
   parameter.ranges = get_feature_set_ranges(feature_set);
end

if isfield(parameter,'thresh_quantize_mt')==0
   parameter.thresh_quantize_mt = 0.1;
end

if isfield(parameter,'hit_threshold')==0
   parameter.hit_threshold = 0.1;
end
if isfield(parameter,'di')==0
   parameter.di = [1,1,2];
end

if isfield(parameter,'dj')==0
   parameter.dj = [1,2,1];
end

if isfield(parameter,'dWeights')==0
   parameter.dWeights = [1,1,2];
end

if isfield(parameter,'match_endExclusionForward')==0
   parameter.match_endExclusionForward = 0;
end
if isfield(parameter,'match_endExclusionBackward')==0
   parameter.match_endExclusionBackward = 0.5;
end
if isfield(parameter,'match_startExclusionForward')==0
   parameter.match_startExclusionForward = 0.5;
end
if isfield(parameter,'match_startExclusionBackward')==0
   parameter.match_startExclusionBackward = 0;
end

if isfield(parameter,'expandV')==0
   parameter.expandV = 1;
end

if isfield(parameter,'outputC')==0
   parameter.outputC = 0;

end
if isfield(parameter,'outputD')==0
   parameter.outputD = 0;
  
end
if isfield(parameter,'outputHits')==0
   parameter.outputHits = 0;
   
end
if isfield(parameter,'outputDelta')==0
   parameter.outputDelta = 0;
  
end
if isfield(parameter,'outputClassificationDelta')==0
   parameter.outputClassificationDelta = 0;
   
end
if isfield(parameter,'match_numMax')==0
   parameter.match_numMax = 100;
end

if isfield(parameter,'vis')==0
   parameter.vis = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
downsampling_fac = 4;
sampling_rate_string = num2str(120/downsampling_fac);
settings = [num2str(5) '_0_' sampling_rate_string];

%initialize output variables
if parameter.outputDelta 
    delta = inf(1, size(databaseFeatures, 2));
else 
    delta = [];
end

if parameter.outputClassificationDelta
    classificationDelta = inf(1, size(databaseFeatures, 2));
else 
    classificationDelta=[];
end

if ~iscell(motionClass)
    motionClass = {motionClass};
end
if parameter.outputHits
    hits = cell(1, length(motionClass));
else
    hits = [];
end

if parameter.outputC
    C = cell(1, length(motionClass));
else 
    C =  [];
end
if parameter.outputD
    D = cell(1, length(motionClass));
else 
    D = [];
end


global VARS_GLOBAL;

for k=1:length(motionClass)
    category = motionClass{k};
    
    if isfield(VARS_GLOBAL, 'motionTemplates') == 0 ||  isfield(VARS_GLOBAL.motionTemplates, category) == 0 % use a global variable to cache motion templates in memory
    
        %%%% load and threshold dtw-motion template
        [motionTemplateReal,motionTemplateWeights] = motionTemplateLoadMatfile(basedir_templates,category,feature_set,settings);
        if (isempty(motionTemplateReal))
            error(['Motion Template for category ' category ' could not be found.']);
        end
        param.thresh_lo = parameter.thresh_quantize_mt;
        param.thresh_hi = 1-param.thresh_lo;
        param.visBool = 0;
        param.visReal = 0;
        param.visBoolRanges = false;
        param.visRealRanges = false;
        param.feature_set_ranges =  parameter.ranges;
        param.feature_set = feature_set;
        param.flag = 0;
        [motionTemplate,weights] = motionTemplateBool(motionTemplateReal,motionTemplateWeights,param);
        VARS_GLOBAL.motionTemplates.(category){1} = motionTemplate;
        VARS_GLOBAL.motionTemplates.(category){2} = weights;        
    else 
        motionTemplate = VARS_GLOBAL.motionTemplates.(category){1};
        weights = VARS_GLOBAL.motionTemplates.(category){2};
    end

    %% compute matches with the motion template
    parameter.visCost      = false;
    %parameter.match_numMax = 5000;
    parameter.match_thresh = parameter.hit_threshold;
    [newHits,newC,newD,newDelta, newClassificationDelta] = motionTemplateDTWRetrievalWeightedForClassification(...
                          motionTemplate,weights,databaseFeatures,...
                            ones(1,size(databaseFeatures,2)),...
                            parameter,...
                            parameter.di,parameter.dj,parameter.dWeights);
                        
    if parameter.outputDelta 
        delta = min(delta, newDelta);
    end
    if parameter.outputClassificationDelta 
        classificationDelta = min (  classificationDelta, newClassificationDelta);
    end
    if parameter.outputHits
        hits{k} = newHits;
    end
    if parameter.outputC
        C{k} = newC;
    end
    if parameter.outputD
        D{k} = newD;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Visualization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%