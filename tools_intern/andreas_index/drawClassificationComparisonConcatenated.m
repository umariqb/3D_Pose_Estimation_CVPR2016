function drawClassificationComparisonConcatenated(files_name, files_frame_start, files_frame_end, classificationResult, manualAnnotation, parameter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: classificationDelta_to_classificationResult
% Version: 1
% Date: 12.08.2008
% Programmer: Andreas Baak
%
% Description: this function draws a figure that compares the
%   manual classification to the automatic classification.
%
% Input:  
%         files_name: cell arrray of filenames that directly correspond to
%         the file indices in classificationResult
%         files_frame_start: vector of file start frames (30Hz) which directly
%         correspond to the indices in files_name and classificationResult
%         files_frame_end: vector of file end frames (30Hz) which directly
%         correspond to the indices in files_name and classificationResult
%         classificationResult: classification struct
%               For every class a field exists. Each field references
%               to a H x 6 matrix, if H hits have been found. 
%               1st: document ID (wrt. DB_concat) to which this hit belongs
%               2nd: start frame of the hit the current document. 
%               3rd: endframe of the hit in the current document. 
%               4rd: start frame of the hit in the database. 
%               5th: endframe of the hit in the database. 
%               6th: cost of that hit.
%         manualAnnotation: manual annotation struct
%
%         parameter.annotationCost = 0;
%         parameter.isSingleClassAnnotation = 0;
%         parameter.showDetailsOnClick = 0;
%         parameter.annotation_database = 0;
%         parameter.annotation_feature_set = 0;
%         parameter.annotation_classDefinition = 0;
%         parameter.annotation_thresh_quantize_mt = 0;
%         parameter.annotation_classDependentThreshold = 0;
%         parameter.displayWarnings = 0;
%
%         parameter.superclasses = {}: set to a cell array of strings if 
%                                      a certain order of the superclasses
%                                      in the figure is desired or if only
%                                      some specific superclasses should be
%                                      drawn in the figure.
%         parameter.docIndices = []: leave empty if all documents should be
%         drawn. Set to some indices in DB_concat if only some documents
%         should be drawn.
%         
%
% Output: 
%         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<6
   parameter=[]; 
end

if nargin<5
   error('Please specify input data');
end

if isfield(parameter,'isSingleClassAnnotation')==0
   parameter.isSingleClassAnnotation = 0;
end

if isfield(parameter,'annotationCost')==0
   parameter.annotationCost = [];
end
if isfield(parameter,'showDetailsOnClick')==0
   parameter.showDetailsOnClick = 0;
end

if parameter.showDetailsOnClick == 1
    if isfield(parameter,'annotation_database')==0 ||...
            isfield(parameter,'annotation_feature_set')==0 ||...
            isfield(parameter,'annotation_classDefinition')==0 ||...            
            isfield(parameter,'annotation_thresh_quantize_mt')==0 ||...            
            isfield(parameter,'annotation_classDependentThreshold')==0 ...
            
        error('Some required data to generate the onClickDetails is not passes in the parameter struct!');
    end
end
    
if isfield(parameter,'displayWarnings')==0
   parameter.displayWarnings = 0;
end

if isfield(parameter,'superclasses')==0
   parameter.superclasses = {};
end
if isfield(parameter,'docIndices')==0
   parameter.docIndices = {};
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
classes = fieldnames(classificationResult);

if ~isempty(parameter.superclasses)
    [temp, IA] = intersect(parameter.superclasses, classes);
    classes = parameter.superclasses(sort(IA, 2, 'descend'));
end


set(gca, 'xlim', [1, files_frame_end(end)]);
set(gca, 'ylim', [0.5, length(classes)*2+0.5 + 2]);

% draw class labels inbetween two rows

yticklabel = classes;
set(gca, 'ytick', [1.5:2:2*length(classes)]);
set(gca, 'yticklabel', yticklabel);

% draw lines that separate the classes in the figure
for c=1:length(classes)
    line([1, files_frame_end(end)], [2*c+0.5, 2*c+0.5]);
end

if isempty(parameter.docIndices)
    parameter.docIndices = 1:length(files_name);
end


for d=parameter.docIndices
    docName = files_name{d};
    
    annotationIdx = strmatch(docName, {manualAnnotation.filename});
    annotations = manualAnnotation(annotationIdx);
    
    if parameter.isSingleClassAnnotation
        expectedSuperClass = fieldnames(annotations.classInfo);
    else
        expectedSuperClass = '';
    end
%    docLength = files_frame_length(d);
    
    
    
    docStart = files_frame_start(d);
    docEnd = files_frame_end(d);
    
    % draw a line at the document end frame
    % draw a line at the document start frame
    handle1 = line([docEnd+0.5, docEnd+0.5], [0.5, length(classes)*2+0.5], 'Color', [1 0 0], 'LineWidth', 1); 
    handle2 = line([docStart-0.5, docStart-0.5], [0.5, length(classes)*2+0.5], 'Color', [1 0 0], 'LineWidth', 1); 
    if ~isempty(parameter.annotationCost)
        ann = parameter.annotationCost;
        if isfield(ann, 'tolerantMatch')
            text(docStart, 2*length(classes)+1, num2str(parameter.annotationCost.tolerantMatch(d), '%.1f'));        
        end
        if isfield(ann, 'counting')
            text(docStart, 2*length(classes)+2, num2str(parameter.annotationCost.counting(d), '%.1f'));        
        end
        if isfield(ann, 'precisionRecall')
        text(docStart, 2*length(classes)+3, ...
            [''  num2str(parameter.annotationCost.precisionRecall(d,1), '%.1f'), '|',...
                 num2str(parameter.annotationCost.precisionRecall(d,2), '%.1f')] );        
        end
    end

    % draw the documents name below the document
    [temp, filename] = fileparts(docName);
    text(docStart, -1.5, filename, 'interpreter', 'none');
    
    
    if parameter.showDetailsOnClick
        set(handle1,'ButtonDownFcn',{@showDeltasForDatabaseDocument,...
                                            parameter.annotation_database,...
                                            parameter.annotation_feature_set,...
                                            d,...
                                            parameter.annotation_classDefinition,...
                                            parameter.annotation_thresh_quantize_mt,...
                                            parameter.annotation_classDependentThreshold,...
                                            docName
                                          });
        set(handle2,'ButtonDownFcn',{@showDeltasForDatabaseDocument,...
                                            parameter.annotation_database,...
                                            parameter.annotation_feature_set,...
                                            d,...
                                            parameter.annotation_classDefinition,...
                                            parameter.annotation_thresh_quantize_mt,...
                                            parameter.annotation_classDependentThreshold,...
                                            docName
                                          });
    end
                                      
                                      
    for c=1:length(classes)
        
        class = classes{c};
        
        if parameter.isSingleClassAnnotation
            if strmatch(class, expectedSuperClass) == true
                color = [0 1 0];
            else
                color = [1 0 0];
            end
        else
            color = [1 0 0];
        end
        
        
        % find out all hits of the current document belonging to the
        % current class (using classificationResult)
        hitData = classificationResult.(class)((classificationResult.(class)(:,1) == d), [2:5, 6]);
        for h=1:size(hitData, 1)
            hitStart = hitData(h, 3);
            hitEnd = hitData(h, 4);
            cost = hitData(h, 5);

            % remap from 30Hz to 120 Hz
            animationStart = hitData(h, 1) * 4 - 4 + 1;
            animationEnd = hitData(h, 2) * 4 - 4 + 1;
        
            %draw rectangle
            %color = [1 0 0]; %[0 127 14]/255;
            yPosition = 2*c - 1;
            
            hitWidth = hitStart-hitEnd;
            if hitWidth == 0
                handle = line([hitStart, hitStart], [yPosition-0.3, yPosition+0.3], 'Color', color, 'LineWidth', 1);
            else
            
            
                handle = rectangle('Position', [hitStart, yPosition-0.3,...
                    hitEnd - hitStart, 0.6],...
                    'EdgeColor', [0 0 0],...
                    'FaceColor', color,...
                    'LineWidth', 1);
            end
            set(handle,'ButtonDownFcn',{@animateRectOnClick,...
                                        docName,...
                                        animationStart,...
                                        animationEnd, ...
                                        cost
                                      });
            
        end
        

        % now draw all manual classifications
        % find out which struct of the manualAnnotation fits to
        % the current document
        %idx = strmatch(docName, {manualAnnotation.filename});
%         if length(idx) < 1 
%             if parameter.displayWarnings == 1
%                 disp(['No manual classifications found for the file ' docName '.']); 
%             end
%             continue;
%         end
        if isempty(annotations)
            if parameter.displayWarnings == 1
                disp(['No manual classifications found for the file ' docName '.']); 
            end
            continue;
        end
        if length(annotations) > 1
            error(['More than one manual classification has been found for document ' docName '.']);
        end
        
        if ~isfield(annotations.classInfo, class)
            if parameter.displayWarnings == 1
                disp(['Manual annotation of class ' class ' not found for document ' docName]);
            end
            continue;
        end
        hitData = annotations.classification{annotations.classInfo.(class)};
        %remap from 120 Hz to 30 Hz
        if ~isempty(hitData)
            hitData(:, 1:2) = floor((hitData(:, 1:2)-1)/4)+1;
        end
        
        
        
        for h=1:size(hitData, 1)
            hitStart = hitData(h, 1);
            hitEnd = hitData(h, 2);
            cost = 0;

            % remap from 30Hz to 120 Hz
            animationStart = hitStart * 4 - 4 + 1;
            animationEnd = hitEnd * 4 - 4 + 1;
        
            %draw rectangle
            color = [0 0 0];
            yPosition = 2*c;
            hitWidth = hitStart-hitEnd;
            
            %remap from local file position to global database position
            hitStart = hitStart + docStart -1 ;
            hitEnd = hitEnd + docStart -1 ;
            
            if hitWidth == 0
                handle = line([hitStart, hitStart], [yPosition-0.3, yPosition+0.3], 'Color', [0,0,0], 'LineWidth', 1);
            else
            
                handle = rectangle('Position', [hitStart, yPosition-0.3,...
                    hitEnd - hitStart, 0.6],...
                    'EdgeColor',  [1 1 1], ... %[0 127 14]/255,...
                    'FaceColor', color,...
                    'LineWidth', 1);
            end
            set(handle,'ButtonDownFcn',{@animateRectOnClick,...
                                        docName,...
                                        animationStart,...
                                        animationEnd, ...
                                        cost,...
                                        parameter.annotation_feature_set,...
                                      });
        end        
        
    end
end




