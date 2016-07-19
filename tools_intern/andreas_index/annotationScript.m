global VARS_GLOBAL;
VARS_GLOBAL.DB = 'HDM05_EG08_cut_amc_training';

%get all categories from the training database
d=dir(fullfile(VARS_GLOBAL.dir_root, VARS_GLOBAL.DB));
directoryIndices = logical(cell2mat({d.isdir}));
directoryIndices(1:2) = 0; % delete '.' and '..' directories
motion_classes = {d(directoryIndices).name};
classDependentThreshold = 0.13*ones(1, length(motion_classes));
% parameter.useQuantizedMT = 1;
% parameter.thresh_quantize_mt = 0.05;
% classDependentThreshold = createClassDependentThresholds('HDM05_EG08_cut_amc_training', parameter);

% if exist('trainedAdaptiveQuantizationThresholds.mat', 'file')
%     load trainedAdaptiveQuantizationThresholds.mat;
% else
%     adaptiveQuantizationThresholds = createQuantizationThresholds('HDM05_EG08_cut_amc_training');
% end
adaptiveQuantizationThresholds = 0.05*ones(1, length(motion_classes));


motion_classes{end+1} = 'standStill2000';
classDependentThreshold(end+1) = 0.06;
adaptiveQuantizationThresholds(end+1) = 0.05;
motion_classes{end+1} = 'tpose1000';
classDependentThreshold(end+1) = 0.06;
adaptiveQuantizationThresholds(end+1) = 0.05;



numMotionClasses = length(motion_classes);


%set up some parameter variables
basedir_templates = fullfile(VARS_GLOBAL.DB, '_templates','');
downsampling_fac = 4;
sampling_rate_string = num2str(120/downsampling_fac);
settings = [num2str(5) '_0_' sampling_rate_string];

feature_set = {'AK_upper', 'AK_lower', 'AK_mix_avr'};
%feature_set = {'FullBodyRelationalBool'};
feature_set_ranges = get_feature_set_ranges(feature_set,1);


max_thresh = max(classDependentThreshold);


%% load annotation database


[DB_concat, indexArray] = DB_index_load('HDM05_CMU_EG08_tiny', feature_set, 4);
%DB_concat = DB_index_load('HDM05_EG08_cut_amc_test', feature_set, 4);
nframes = length(DB_concat.features);


%% get classification-delta-curves for each motion class


%classDependentThreshold(53) = 0.12;

parameter.outputHits = 0;
parameter.outputC = 0;
parameter.outputD = 0;
parameter.outputDelta = 1;
parameter.outputClassificationDelta = 1;
parameter.match_numMax = 2000;
useKeyframesFunction = 'manualKeyframesForAnnotation_avr';
%useKeyframesFunction = '';
if exist('useKeyframesFunction', 'var') && ~isempty(useKeyframesFunction)
    deltaK = inf*ones(numMotionClasses, length(DB_concat.features(:,:)));
    classificationDeltaK = inf*ones(numMotionClasses, length(DB_concat.features(:,:)));
else
    delta = inf*ones(numMotionClasses, length(DB_concat.features(:,:)));
    classificationDelta = inf*ones(numMotionClasses, length(DB_concat.features(:,:)));
end

parameter.visKeyframeSearchForMotionClasses=[70];

parameter.match_endExclusionForward = 0;
parameter.match_endExclusionBackward = 0.5;
parameter.match_startExclusionForward = 0.5;
parameter.match_startExclusionBackward = 0;

% clear previously cached motion templates
if isfield(VARS_GLOBAL,  'motionTemplates')
    VARS_GLOBAL=rmfield(VARS_GLOBAL, 'motionTemplates');
end

for c=1:length(motion_classes)
    disp(['Computing delta of class ' num2str(c) ': ' motion_classes{c}]);
    parameter.hit_threshold = classDependentThreshold(c);
    parameter.thresh_quantize_mt = adaptiveQuantizationThresholds(c);
    
   if exist('useKeyframesFunction', 'var') && ~isempty(useKeyframesFunction)
        % load keyframes
        keyframesFunction = str2func(useKeyframesFunction);
        [motionTemplateKeyframes, motionTemplateKeyframePositions, motionTemplateKeyframesIndex, motionTemplateKeyframeDistances, stiffness, templateLength] = keyframesFunction(motion_classes{c});
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
        %% Visualize the keyframe search result
        if ~isempty(intersect(c, parameter.visKeyframeSearchForMotionClasses))
            [segments,framesTotalNum] = keyframeSearch(motionTemplateKeyframes,...
                                            motionTemplateKeyframesIndex,...
                                            motionTemplateKeyframeDistances,...
                                            stiffness,...
                                            indexArray, ...
                                            extendLeft, ...
                                            extendRight,...
                                            DB_concat);
            height=39;
            set(gcf, 'name', ['DB_concat with keyframe search for ' motion_classes{c}]);
            for k=1:size(DB_concat.files_name)
                l= line(DB_concat.files_frame_start(k), mod(k, height)+1, ...
                    'Marker', '.',...
                    'Color', 'magenta');
                set(l, 'MarkerSize', 15);
                set(l, 'buttondownfcn',{@showFeatures,...
                                          DB_concat.files_name{k}, ...
                                          feature_set,...
                                          motionTemplateKeyframes,...
                                          motionTemplateKeyframesIndex,...
                                          motionTemplateKeyframeDistances,...
                                          stiffness,...
                                          extendLeft,...
                                          extendRight...
                                  });  
            end
            figure;
            for keyframeNr = 1:length(motionTemplateKeyframes)
                subplot(1,length(motionTemplateKeyframes), keyframeNr);
                imagesc(motionTemplateKeyframes{keyframeNr});
                colormap gray;
                caxis([0 1]);
                title(['idx: ' num2str(motionTemplateKeyframesIndex(keyframeNr)) ', pos: ' num2str(motionTemplateKeyframePositions(keyframeNr))] );
                set(gca, 'xtick', 1),
                h = ylabel('');
                fspec=load(['fspec_' feature_set{motionTemplateKeyframesIndex(keyframeNr)} '.mat']);
                Ylabels = strvcat(fspec.features_spec(feature_set_ranges{motionTemplateKeyframesIndex(keyframeNr)}).name);
                set(h,'interpreter','none');  
                set(gca,'YTickLabel',Ylabels);
                set(gca, 'Ytick', [1:length(Ylabels)]);            

            end            
            set(gcf, 'position',  [  1607         738        1005         391]);        
            set(gcf, 'name', ['Keyframes: ' motion_classes{c}] );
        end
                                    
                                    

        for i = 1:size(segments, 2)
            d = segments(1,i);
            %fprintf('%i ', d);
            frameStart = DB_concat.files_frame_start(d) + segments(2,i) - 1;
            frameEnd = DB_concat.files_frame_start(d) + segments(3,i) - 1;
            [temp, temp, temp, deltaK(c, frameStart:frameEnd), classificationDeltaK(c,frameStart:frameEnd)] = motionClass_to_Delta(motion_classes{c}, DB_concat.features(:, frameStart:frameEnd), basedir_templates, feature_set, parameter);
        end

    else
    
        for d = 1:length(DB_concat.files_name)
            fprintf('%i ', d);
            frameStart = DB_concat.files_frame_start(d);
            frameEnd = DB_concat.files_frame_end(d);
            [temp, temp, temp, delta(c, frameStart:frameEnd), classificationDelta(c,frameStart:frameEnd)] = motionClass_to_Delta(motion_classes{c}, DB_concat.features(:, frameStart:frameEnd), basedir_templates, feature_set, parameter);
        end
        fprintf('\n');
    %[temp, temp, temp, delta(c, :), classificationDelta(c,:)] = motionClass_to_Delta(motion_classes{c}, DB_concat.features, basedir_templates, feature_set, parameter);
   end
end

%now postprocess classificationDelta: convert deltas of single classes
% to deltas of combined classes
classDefinition = createClassDefinition;

if exist('useKeyframesFunction', 'var') && ~isempty(useKeyframesFunction)
    [classificationDeltaSuperClassesK, superClassesNames] = combineDelta(classificationDeltaK, motion_classes, classDefinition);         
    deltaSuperClassesK = combineDelta(deltaK, motion_classes, classDefinition);
    parameter.files_frame_start = DB_concat.files_frame_start;
    parameter.files_name = DB_concat.files_name;
    [classificationResultK] = classificationDelta_to_classificationResult(classificationDeltaSuperClassesK,superClassesNames, DB_concat.files_frame_start, DB_concat.files_frame_length, parameter);
    
else
    [classificationDeltaSuperClasses, superClassesNames] = combineDelta(classificationDelta, motion_classes, classDefinition);         
    deltaSuperClasses = combineDelta(delta, motion_classes, classDefinition);
    parameter.files_frame_start = DB_concat.files_frame_start;
    parameter.files_name = DB_concat.files_name;
    [classificationResult] = classificationDelta_to_classificationResult(classificationDeltaSuperClasses,superClassesNames, DB_concat.files_frame_start, DB_concat.files_frame_length, parameter);
end
                      

% parameter.vis = 1;
% parameter.createOnClicks = 1;


%% visualize classificationResult, compare it to the manual classification

manualClassificationResult = manualClassificationTiny();
%manualClassificationResult = manualClassificationGenerated;
% documents=[2, 3, 4];
% classesPerDocument = { {'walk2StepsLstart_walk2StepsRstart', 'sit', 'jump', 'throw'}, ...
%     {'walk2StepsLstart_walk2StepsRstart', 'sit', 'jump'},...
%     {'walk2StepsLstart_walk2StepsRstart', 'sit', 'jump',
%     'standStill500'}};
% 
% documents=[2];
% classesPerDocument = { {'walk2StepsLstart_walk2StepsRstart', 'sit', 'jump', 'throw'}};

%documents = []%1%:10%1:length(DB_concat.files_name);
documents = [1:length(DB_concat.files_name)];
superClasses = fieldnames(classDefinition);

classesPerDocument = repmat({ superClasses }, 1, length(documents));

parameter.printFigure = false;
parameter.filenamePrefix = 'figures/classificationComparison_newAdaptiveQ_tiny_constantThresholds_013_';
drawClassificationComparison(DB_concat, classificationResult, manualClassificationResult, documents, classesPerDocument, parameter)

parameter.printFigure = false;
parameter.filenamePrefix = 'figures/classificationComparison_newKAdaptiveQ_tiny_constantThresholds_013_';
drawClassificationComparison(DB_concat, classificationResultK, manualClassificationResult, documents, classesPerDocument, parameter)


%% visualize complete classification with evaluation in one figure 
parameter.displayCost=0;

 parameter.evaluationMethod = 'all' ;
[allAnnotationCost.tolerantMatch, ...
 allAnnotationCost.precisionRecall, ...
 allAnnotationCost.counting] = evaluateClassification(DB_concat.files_name, DB_concat.files_frame_length, classificationResultK, manualClassificationResult, parameter);

allAnnotationMean.tolerantMatch = mean(allAnnotationCost.tolerantMatch);
allAnnotationVar.tolerantMatch = var(allAnnotationCost.tolerantMatch);
allAnnotationMean.counting = mean(allAnnotationCost.counting);
allAnnotationVar.counting = var(allAnnotationCost.counting);
precision = allAnnotationCost.precisionRecall(:,1);
recall = allAnnotationCost.precisionRecall(:,2);
fmeasure = 2*precision.*recall./(precision+recall);
fmeasure(isnan(fmeasure)) = 0;
allAnnotationMean.precisionRecall = mean(fmeasure);
allAnnotationVar.precisionRecall = var(fmeasure);

parameter.isSingleClassAnnotation = 0;
parameter.annotationCost = allAnnotationCost;
parameter.showDetailsOnClick = 1;
parameter.annotation_database = 'HDM05_CMU_EG08_tiny';
parameter.annotation_feature_set =  feature_set;
parameter.annotation_classDefinition = createClassDefinition;
parameter.annotation_thresh_quantize_mt =  parameter.thresh_quantize_mt;
parameter.annotation_classDependentThreshold = classDependentThreshold;
drawClassificationComparisonConcatenated(DB_concat.files_name, DB_concat.files_frame_start, DB_concat.files_frame_end, classificationResultK, manualClassificationResult, parameter)


[allAnnotationCost.tolerantMatch, ...
 allAnnotationCost.precisionRecall, ...
 allAnnotationCost.counting] = evaluateClassification(DB_concat.files_name, DB_concat.files_frame_length, classificationResult, manualClassificationResult, parameter);
parameter.annotationCost = allAnnotationCost;
parameter.showDetailsOnClick = 1;
parameter.annotation_database = 'HDM05_CMU_EG08_tiny';
parameter.annotation_feature_set =  feature_set;
parameter.annotation_classDefinition = createClassDefinition;
parameter.annotation_thresh_quantize_mt =  parameter.thresh_quantize_mt;
parameter.annotation_classDependentThreshold = classDependentThreshold;

parameter.isSingleClassAnnotation = 0;
drawClassificationComparisonConcatenated(DB_concat.files_name, DB_concat.files_frame_start, DB_concat.files_frame_end, classificationResult, manualClassificationResult, parameter)

%% 
manualClassificationResult = manualClassificationTiny();

parameter.manualClassificationResult = manualClassificationResult; 
parameter.cmap = hot(64);
parameter.cAxisLimits = [0, 0.2];
document  = 23;

% parameter.deltaAll = 0;
% parameter.deltaSuper = 0;
% parameter.cdeltaAll = 1;
% parameter.cdeltaSuper = 0;
% drawAnnotationDeltas(DB_concat, document, motion_classes, delta, classificationDelta, parameter);

% parameter.deltaAll = 0;
% parameter.deltaSuper = 0;
% parameter.cdeltaAll = 1;
% parameter.cdeltaSuper = 0;
% drawAnnotationDeltas(DB_concat, document, motion_classes, deltaK, classificationDeltaK, parameter);
% 
% parameter.deltaAll = 0;
% parameter.deltaSuper = 0;
% parameter.cdeltaAll = 0;
% parameter.cdeltaSuper = 1;
% drawAnnotationDeltas(DB_concat, document, motion_classes, delta, classificationDelta, parameter);
% 
parameter.deltaAll = 0;
parameter.deltaSuper = 0;
parameter.cdeltaAll = 1;
parameter.cdeltaSuper = 1;
drawAnnotationDeltas(DB_concat, document, motion_classes, deltaK, classificationDeltaK, parameter);


% %% print deltas of one document
% document = 1;
% 
% startFrame = DB_concat.files_frame_start(document);
% endFrame = DB_concat.files_frame_end(document);
% docLength = DB_concat.files_frame_length(document);
% deltaToDraw = deltaSuperClasses(:, startFrame: endFrame);
% ylabels = superClassesNames;
% numClasses = size(deltaSuperClasses, 1);
% 
% %reorder classiciationDelta: jump, throw, pick, lie, sit, run, walk, neutral
% %classificationDeltaToDraw = classificationDeltaToDraw([7, 3, 6, 4, 5, 2, 1, 8],:);
% 
% max_offset = ceil(max(max(deltaToDraw(deltaToDraw<inf)))*10) / 10;
% if isempty(max_offset)
%     error('All deltas are infinity');
% end
% %max_offset = max_thresh;
% 
% offsetY = cumsum(max_offset*ones(size(deltaToDraw)), 1) - max_offset;
% deltaToDraw = deltaToDraw + offsetY;
% 
% figure;
% for i=1:size(deltaToDraw, 1)
%     line([1, size(deltaToDraw, 2)], [i*max_offset, i*max_offset]);
% end
% hold on;
% plot(deltaToDraw', 'k-')
% set(gca, 'box', 'off');
% 
% set(gca, 'xlim', [1, docLength]);
% set(gca, 'ylim', [0, max_offset*numClasses]);
% set(gca, 'ytick', [max_offset/2:max_offset:max_offset*numClasses]);
% 
% 
% set(gca, 'yticklabel', ylabels);
% paperPosition = [0 0 4 2.5];
% set(gcf, 'paperPosition', paperPosition);
% filename =  ['../figures/classificationDelta_' extractFilenameFromPath(DB_concat.files_name{document}) '.eps'];
% %print('-depsc2', filename);
% 
% %% check the classification on the subclass level on the cut eval database
% [classificationResultSubClasses] = classificationDelta_to_classificationResult(classificationDelta,motion_classes, DB_concat.files_frame_start, DB_concat.files_frame_length, parameter);
% 
% classes = fieldnames(classificationResultSubClasses);
% for c=1:length(classes)
%     category = classes{c};
%     disp(['Class ' num2str(c) ': ' category]);
%     num_relevant = 0;
%     filenames_relevant = cell(length(DB_concat.files_name),1);
%     for d=1:length(DB_concat.files_name)
%         I = findstr(DB_concat.files_name{d},category);
%         if (~isempty(I))
%             num_relevant = num_relevant+1;
%             filenames_relevant{num_relevant} = DB_concat.files_name{d};
%         end
%     end
%     filenames_relevant = filenames_relevant(1:num_relevant);
%     disp(['#(Relevant files):           ' num2str(num_relevant)]);
% 
%     filenums_retrieved = classificationResultSubClasses.(category)(:,1);
%     num_retrieved = length(filenums_retrieved);
%     filenames_retrieved = DB_concat.files_name(filenums_retrieved);
%     [x,I] = intersect(filenames_relevant,filenames_retrieved);
%     num_relevant_retrieved = length(I);
%     disp(['#(Retrieved files):          ' num2str(num_retrieved)]);    
%     disp(['#(Retrieved relevant files): ' num2str(num_relevant_retrieved)]); 
% 
%     falseNegativeFileIDs = setdiff([1:num_relevant], I);
%     if ~isempty(falseNegativeFileIDs)
%         disp('False negatives: ');
%         for f=falseNegativeFileIDs
%             disp(['   ' filenames_relevant{f}]);
%         end
%     end
%     
%     falsePositiveFiles = setdiff(filenames_retrieved, filenames_relevant);
%     if ~isempty(falsePositiveFiles)
%         disp('False positives: ');
%         for f=1:length(falsePositiveFiles)
%             disp(['   ' falsePositiveFiles{f}]);
%         end
%     end
%        
%       
%    
%     fprintf('\n');
%     
% end
% 
% %% 
