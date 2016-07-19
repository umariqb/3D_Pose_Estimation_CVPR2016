function [outputClassification, classificationResult, delta, classificationDelta, subclassNames] = ...
    superclassAnnotation(annotationDB, trainingDB, parameter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: superClassAnnotation
% Version: 1
% Date: 11.09.2008
% Programmer: Andreas Baak
%
% Description: 
%
% Input:
%
%   annotationDB: database name wich should be annotated.
%   trainingDB:       database name of which the motion templates have
%                     been learned previously
%
%   parameter.docNames = {}
%       Cell array of strings. Leave empty if all documents in the 
%       annotationDB should be annotated. 
%       If only some specific documents in the annotationDB should be
%       annotated then insert the filenames as strings in the cell array.
%   parameter.keyframeFunction = 'manualKeyframesForAnnotation':  
%       string value, denotes a function name. If set to a nonempty string,
%       motion classes are determined on a database that has
%       previously been cut down by a keyframe search method, the keyframes
%       have to be defined in the denoted keyframeFunction.
%   parameter.superclasses = {}: 
%       cell arrray of strings. Defines the superclasses
%       that should be used to annotate the
%       annotationDB. The names of the superclasses
%       should be defined in the script
%       createClassDefinition.m
%       if left empty then a default set of superclasses will be used.
%   parameter.outputProgress = false: 
%       set to true if some console output
%       about the current state of the calculations should be made
%   parameter.vis = 0
%       Set it to one if you want the annotation results to be visualized,
%       one figure per annotated document
%   parameter.visCombined = 0
%       Set it to one if you want the annotation results to be visualized,
%       all documents in one figure.
%   parameter.manualAnnotationFunction = 'manualClassificationTiny'
%       set this to the function name which returns the ground truth manual 
%       annotation of the annotationDB. This is only valid if a
%       visualization should be done. 
%   parameter.feature_set = {'AK_upper', 'AK_lower', 'AK_mix'}:
%       feature set that should be used for keyframes and motion templates
%   parameter.hitThresh = 0.13
% Output:
%   outputClassification: struct, one field for each superclass. 
%       each field contains a Hx3 struct if H regions have been assigned to
%       the specific superclass. First column: start frame in the document.
%       Second column: end frame in the document. Third column: document
%       filename relative to VARS_GLOBAL.dir_root.
%   classificationResult: 
%       a struct that saves the results of the classification in a
%       different way. For every class a field exists. Each field references
%       to a H x 6 matrix, if H regions have been found in that subclass.
%       1st: document ID (wrt. DB_concat) to which this hit belongs
%       2nd: start frame of the hit the current document. 
%       3rd: endframe of the hit in the current document. 
%       4rd: start frame of the hit in the database. 
%       5th: endframe of the hit in the database. 
%       6th: cost of that hit.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<2
   error('Please specify input data');
end

if nargin<3
   parameter=[]; 
end


if isfield(parameter,'docNames')==0
   parameter.docNames = {}; %all documents
end

if isfield(parameter,'feature_set')==0
   parameter.feature_set = {'AK_upper', 'AK_lower', 'AK_mix'};
end
if isfield(parameter,'keyframeFunction')==0
   parameter.keyframeFunction = 'manualKeyframesForAnnotation';
end
if isfield(parameter,'outputProgress')==0
   parameter.outputProgress = false;
end
if isfield(parameter,'superclasses')==0
   parameter.superclasses = {...
       'neutral',...
       'tpose',...
       'move',...
       'turn',...
       'sitLieDown',...
       'standUp',...
       'hopOneLeg', ...
       'jump',...
       'kick',...
       'punch',...
       'rotateArms',...
       'throwR',...
       'grabDepR',...
       'cartwheel',...
       'exercise'};
end


if isfield(parameter,'visCombined')==0
   parameter.visCombined = false;
end
if isfield(parameter,'vis')==0
   parameter.vis = false;
end
if isfield(parameter,'manualAnnotationFunction')==0
   parameter.manualAnnotationFunction = 'manualClassificationTiny';
end
if isfield(parameter,'hitThresh')==0
   parameter.hitThresh = 0.13;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global VARS_GLOBAL;

% always use all available subclasses for classification to gain stable
% classification results. Now get all available subclasses.
classDefinition = createClassDefinition();
availableSuperClasses = fieldnames(classDefinition);
subclassNames = cell(0,0);
for s=1:length(availableSuperClasses)
    subclasses = classDefinition.(availableSuperClasses{s});
    subclassNames(1,end+1:end+length(subclasses)) = subclasses;
end    

%now change the classDefinition struct so that only
%parameter.superclasses will be used.

superclassesToRemove = setdiff(availableSuperClasses, intersect(availableSuperClasses, parameter.superclasses));
classDefinition = rmfield(classDefinition, superclassesToRemove);
if length(fieldnames(classDefinition)) < length(parameter.superclasses)
    error('At least one of the parameter.superclasses could not be found in the createClassDefinition.m script!');
end

numSubClasses = length(subclassNames);

classDependentThreshold = parameter.hitThresh*ones(1, numSubClasses);
adaptiveQuantizationThresholds = 0.05*ones(1, numSubClasses);

%set up some parameter variables
basedir_templates = fullfile(trainingDB, '_templates','');
downsampling_fac = 4;

%% load annotation database

[DB_concat, indexArray] = DB_index_load(annotationDB, parameter.feature_set, downsampling_fac);

DB_concat_filenames = DB_concat.files_name;


% convert parameter.docNames to the associtated indices in the DB_concat.
if isempty(parameter.docNames)
    docIndices = 1:length(DB_concat.files_name);
else
    docIndices = [];
    docNames = parameter.docNames;
    for d=1:length(docNames)
        idx = strmatch(docNames{d}, DB_concat_filenames);
        if isempty(idx)
            warning(['Document ' docNames{d} ' not found in the annotation database ' annotationDB '.']);
        else 
            docIndices(end+1) = idx;
        end
    end    
end

if isempty(docIndices)
    outputClassification = struct;
    warning('There is no document that I should annotate, so I am going to return an empty struct.');
    return;    
end
%% get classification-delta-curves for each motion class

parameter.outputHits = 0;
parameter.outputC = 0;
parameter.outputD = 0;
parameter.outputDelta = 1;
parameter.outputClassificationDelta = 1;
parameter.match_numMax = 2000;
% if ~isempty(parameter.keyframeFunction)
%     useKeyframesFunction = 'manualKeyframesForAnnotation';
% end

delta = inf*ones(numSubClasses, length(DB_concat.features(:,:)));
classificationDelta = inf*ones(numSubClasses, length(DB_concat.features(:,:)));

% parameter.visKeyframeSearchForMotionClasses=[];

parameter.match_endExclusionForward = 0;
parameter.match_endExclusionBackward = 0.5;
parameter.match_startExclusionForward = 0.5;
parameter.match_startExclusionBackward = 0;

% clear previously cached motion templates
if isfield(VARS_GLOBAL,  'motionTemplates')
    VARS_GLOBAL=rmfield(VARS_GLOBAL, 'motionTemplates');
end

for c=1:length(subclassNames)
    if parameter.outputProgress
        disp(['Computing delta of class ' num2str(c) ': ' subclassNames{c}]);
    end
    parameter.hit_threshold = classDependentThreshold(c);
    parameter.thresh_quantize_mt = adaptiveQuantizationThresholds(c);
    
   if ~isempty(parameter.keyframeFunction)
        % load keyframes
        keyframesFunction = str2func(parameter.keyframeFunction);
        [motionTemplateKeyframes, motionTemplateKeyframePositions, motionTemplateKeyframesIndex, motionTemplateKeyframeDistances, stiffness, templateLength] = keyframesFunction(subclassNames{c});
        extendLeft = (motionTemplateKeyframePositions(1)-1)*2;
        extendRight = (templateLength - motionTemplateKeyframePositions(end))*2;

        % cut down search space using keyframes
        [segments,framesTotalNum] = keyframeSearchEfficient(motionTemplateKeyframes,...
                                        motionTemplateKeyframesIndex,...
                                        motionTemplateKeyframeDistances,...
                                        stiffness,...
                                        indexArray, ...
                                        extendLeft, ...
                                        extendRight);
%         %% Visualize the keyframe search result
%         if ~isempty(intersect(c, parameter.visKeyframeSearchForMotionClasses))
%             [segments,framesTotalNum] = keyframeSearch(motionTemplateKeyframes,...
%                                             motionTemplateKeyframesIndex,...
%                                             motionTemplateKeyframeDistances,...
%                                             stiffness,...
%                                             indexArray, ...
%                                             extendLeft, ...
%                                             extendRight,...
%                                             DB_concat);
%             height=39;
%             set(gcf, 'name', ['DB_concat with keyframe search for ' subclassNames{c}]);
%             for k=1:size(DB_concat.files_name)
%                 l= line(DB_concat.files_frame_start(k), mod(k, height)+1, ...
%                     'Marker', '.',...
%                     'Color', 'magenta');
%                 set(l, 'MarkerSize', 15);
%                 set(l, 'buttondownfcn',{@showFeatures,...
%                                           DB_concat.files_name{k}, ...
%                                           feature_set,...
%                                           motionTemplateKeyframes,...
%                                           motionTemplateKeyframesIndex,...
%                                           motionTemplateKeyframeDistances,...
%                                           stiffness,...
%                                           extendLeft,...
%                                           extendRight...
%                                   });  
%             end
%             figure;
%             for keyframeNr = 1:length(motionTemplateKeyframes)
%                 subplot(1,length(motionTemplateKeyframes), keyframeNr);
%                 imagesc(motionTemplateKeyframes{keyframeNr});
%                 colormap gray;
%                 caxis([0 1]);
%                 title(['idx: ' num2str(motionTemplateKeyframesIndex(keyframeNr)) ', pos: ' num2str(motionTemplateKeyframePositions(keyframeNr))] );
%                 set(gca, 'xtick', 1),
%                 h = ylabel('');
%                 fspec=load(['fspec_' feature_set{motionTemplateKeyframesIndex(keyframeNr)} '.mat']);
%                 Ylabels = strvcat(fspec.features_spec(feature_set_ranges{motionTemplateKeyframesIndex(keyframeNr)}).name);
%                 set(h,'interpreter','none');  
%                 set(gca,'YTickLabel',Ylabels);
%                 set(gca, 'Ytick', [1:length(Ylabels)]);            
% 
%             end            
%             set(gcf, 'position',  [  1607         738        1005         391]);        
%             set(gcf, 'name', ['Keyframes: ' subclassNames{c}] );
%         end

        

        for i = 1:size(segments, 2)
            d = segments(1,i);
            if sum(docIndices==d) > 0
                frameStart = DB_concat.files_frame_start(d) + segments(2,i) - 1;
                frameEnd = DB_concat.files_frame_start(d) + segments(3,i) - 1;
                [temp, temp, temp, delta(c, frameStart:frameEnd), classificationDelta(c,frameStart:frameEnd)] = motionClass_to_Delta(subclassNames{c}, DB_concat.features(:, frameStart:frameEnd), basedir_templates, parameter.feature_set, parameter);
            end
        end

    else
    
        for d = docIndices
            if parameter.outputProgress 
                 fprintf('%i ', d);
            end
            frameStart = DB_concat.files_frame_start(d);
            frameEnd = DB_concat.files_frame_end(d);
            [temp, temp, temp, delta(c, frameStart:frameEnd), classificationDelta(c,frameStart:frameEnd)] = motionClass_to_Delta(subclassNames{c}, DB_concat.features(:, frameStart:frameEnd), basedir_templates, parameter.feature_set, parameter);
        end
        if parameter.outputProgress 
            fprintf('\n');
        end
    end
end

[classificationDeltaSuperClasses, superClassesNames] = combineDelta(classificationDelta, subclassNames, classDefinition);         
%deltaSuperClasses = combineDelta(delta, subclassNames, classDefinition);
parameter.files_frame_start = DB_concat.files_frame_start;
parameter.files_name = DB_concat.files_name;
[classificationResult] = classificationDelta_to_classificationResult(classificationDeltaSuperClasses,superClassesNames, DB_concat.files_frame_start, DB_concat.files_frame_length, parameter);


outputClassification = struct;
for s=1:length(superClassesNames)
    data = classificationResult.(superClassesNames{s})(:,2:3);
    outputClassification.(superClassesNames{s}) = num2cell(data);
    outputClassification.(superClassesNames{s})(:,3) = DB_concat.files_name(classificationResult.(superClassesNames{s})(:,1));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Visualization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
if parameter.vis || parameter.visCombined
    if ~isempty(parameter.manualAnnotationFunction)
        maualAnnotationFunction = str2func(parameter.manualAnnotationFunction);
        manualClassificationResult = maualAnnotationFunction();
    else
        manualClassificationResult=struct('filename', []);
    end
end
    
if parameter.vis    
    classesPerDocument = repmat({ fliplr(parameter.superclasses) }, 1, length(docIndices));

    parameter.printFigure = false;
    drawClassificationComparison(DB_concat, classificationResult, manualClassificationResult, docIndices, classesPerDocument, parameter)
end
    
if parameter.visCombined
    parameter.isSingleClassAnnotation = 0;
    parameter.annotation_feature_set =  parameter.feature_set;
    parameter.docIndices = docIndices;
    drawClassificationComparisonConcatenated(DB_concat.files_name, DB_concat.files_frame_start, DB_concat.files_frame_end, classificationResult, manualClassificationResult, parameter)
end

