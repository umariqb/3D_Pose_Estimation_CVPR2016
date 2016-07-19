function [classificationResult, classificationDeltaSuperClasses] = classificationDelta_to_classificationResult(classificationDeltaSuperClasses,  superClassesNames, files_frame_start, files_frame_length, parameter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: classificationDelta_to_classificationResult
% Version: 1
% Date: 06.08.2008
% Programmer: Andreas Baak
%
% Description: 
%
% Input:  
%         classificationDeltaSubClasses:
%         subClassesNames: defines which row in classificationDelta belongs
%         to which motionClass
%         classDefinition: A struct. Each field defines a class using a
%         cell array of strings. E.g. 
%         classDefinition.walk = {'walkLeft', 'walkRight'} 
%         would mean that the class named 'walk' include the
%         classificationDelta of the motion classes 'walkLeft' and
%         'walkRight'.
%         
%         parameter.extendLeft = true If set to true, each hit will be
%         extended to the left by following the classificationDelta in a monotonously 
%         decreasing way.
%         parameter.extendRight = true If set to true, each hit will be
%         extended to the right by following the classificationDelta in a monotonously 
%         decreasing way.
%         parameter.vis = 0;
%         parameter.vis = 0;
%         parameter.vis = 0;

%         
%
% Output: 
%         classificationResult a struct that saves the results of the
% classification. For every class a field exists. Each field references
% to a H x 6 matrix, if H hits have been found. 
% 1st: document ID (wrt. DB_concat) to which this hit belongs
% 2nd: start frame of the hit the current document. 
% 3rd: endframe of the hit in the current document. 
% 4rd: start frame of the hit in the database. 
% 5th: endframe of the hit in the database. 
% 6th: cost of that hit.
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

if isfield(parameter,'extendLeft')==0
   parameter.extendLeft = true;
end
if isfield(parameter,'extendRight')==0
   parameter.extendRight = true;
end
% if isfield(parameter,'outputDelta')==0
%    parameter.outputDelta = 0;
%    deltaSuperClasses = [];
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nframes = size(classificationDeltaSuperClasses, 2);

minCost = inf*ones(1, nframes);
minClass = zeros(1, nframes);

classificationResult = struct();
for i=1:length(superClassesNames)
    classificationResult.(superClassesNames{i}) = zeros(0, 6);
    %classificationResult.threshold.(motionClassesNames{i}) = classDependentThreshold(i);
end

for f=1:nframes
    [minCost(f), minClass(f)] = min(classificationDeltaSuperClasses(:,f));
    if (minCost(f) == inf)
        minClass(f) = 0;
    end
    
end


% classColors = [ 1 0 0 ; ... % 'red'
%                 0 1 0 ; ... %  green
%                 0 0 1 ; ... %'blue', 
%                 1 1 0 ; ... % yellow
%                 1 0 1 ; ... %'magenta', 
%                 0 1 1 ; ... % cyan
%                 0 0 0 ; ...  % 'black'
%                 0 0 0 ;];
%classColors = repmat ([0,0,0], numMotionClasses, 1);            
            
%figure;

[runs,runs_start,runs_length] = runs_find_constant(minClass);
%runs: sequence of classes IDs that are the minimum classes for a specific
%amount of frames
%runs_start(r): start frame of the minimum run of class runs(r)
%runs_length(r): length of the mimum section of class runs(r) from start
%frame runs_start(r) on.

baseDocument = 1; %saves the index in which document of the database the current hit takes place


for r=1:length(runs)
    if (runs(r) > 0)
        while 1
            baseDocument = baseDocument + 1 ;
             if (baseDocument > length(files_frame_start)) ||...
                (runs_start(r) < files_frame_start(baseDocument))
                    break;
             end
            % currentDocument should point into the DB_concat - document in
            % which the current run takes place
        end
        baseDocument = baseDocument - 1 ;

        % now r points into the current run. The run will now be extended
        % to its full original hit length. Therefore the
        % classificationDelta curve at the current position will be
        % traversed to the left and to the right in a monotonic decreasing
        % way. The right and left borders then are taken as borders of the
        % rectangle and animation so that the full semantic hit is shown.
        thisRunStart = runs_start(r);
%       cost = classificationDelta(runs(r), thisRunStart);
        startCost = classificationDeltaSuperClasses(runs(r), thisRunStart);
        
        if parameter.extendLeft
            while true
                thisRunStart = thisRunStart-1;
                %if (thisRunStart < files_frame_start(currentDocument)) || ...
                if (thisRunStart < 1) || ...
                        (classificationDeltaSuperClasses(runs(r), thisRunStart)> startCost) 
                    break;
                end
                startCost = classificationDeltaSuperClasses(runs(r), thisRunStart);
            end
            thisRunStart = thisRunStart+1;
        end

        thisRunEnd = runs_start(r) + runs_length(r)-1;
        
        endCost = classificationDeltaSuperClasses(runs(r), thisRunEnd); 
        if parameter.extendRight
            while true
                thisRunEnd = thisRunEnd+1;
                %if (thisRunEnd > (files_frame_start(currentDocument) + files_frame_length(currentDocument) -1)) ||...
                %if (thisRunEnd > (files_frame_start(end) + files_frame_length(end) -1)) ||...
                if        thisRunEnd > size(classificationDeltaSuperClasses, 2) || ...
                    (classificationDeltaSuperClasses(runs(r), thisRunEnd) > endCost) 
                    break;
                end
                endCost = classificationDeltaSuperClasses(runs(r), thisRunEnd);
            end
            thisRunEnd = thisRunEnd-1;
        end
        
        cost = min(startCost, endCost);
        
        
        
        hitRange = [thisRunStart:thisRunEnd];
        currentDocument = baseDocument;
        intersection = 1; %initzialized as non-empty
        
        %move backwards from baseDocument and find the first 
        %document that intersected with the hitRange.
        while ~isempty(intersection) && currentDocument >= 1
            docStart = files_frame_start(currentDocument);
            docEnd = docStart + files_frame_length(currentDocument)-1;
            intersection = intersect(hitRange, docStart:docEnd);
            if isempty(intersection)
                break;
            end
            currentDocument = currentDocument - 1 ;
        end
        currentDocument = currentDocument + 1;
        %move forward from currentDocument on and check for intersections of
        %the classification with previous documents
        intersection = 1; % initialize nonemtpy
        while ~isempty(intersection) && currentDocument <= length(files_frame_start)
            docStart = files_frame_start(currentDocument);
            docEnd = docStart + files_frame_length(currentDocument)-1;
            intersection = intersect(hitRange, docStart:docEnd);
            if ~isempty(intersection)
                thisRunStart = intersection(1);
                thisRunEnd = intersection(end);
                thisRunStartInDocument = thisRunStart - files_frame_start(currentDocument)+1;
                thisRunEndInDocument = thisRunEnd - files_frame_start(currentDocument)+1;
                % check if there has been an annotation for this document
                % before. If so, merge all previous annotations with the
                % new one.
                previousAnnotations = classificationResult.(superClassesNames{runs(r)});
                rows = find(previousAnnotations(:,1) == currentDocument);
                                
%                 if ~isempty(classificationResult.(superClassesNames{runs(r)})) && ...
%                     ((classificationResult.(superClassesNames{runs(r)})(end,5) >=  thisRunStart))
                if ~isempty(rows) %the annotations have to be merged
                    previousAnnotationData = previousAnnotations(rows, [4,5,6]);
                    annotationData = [previousAnnotationData; thisRunStart, thisRunEnd, cost];
                    startFrames = annotationData(:, 1);
                    [sortedStartFrames, sortMap] = sort(startFrames);
                    annotationData=annotationData(sortMap, :);
                    newAnnotation = annotationData(1,:);
                    for a=2:size(annotationData, 1)
                        if (annotationData(a, 1) <= newAnnotation(end,2))
                            %overlapping annotations
                            newAnnotation(end, 2) = max(newAnnotation(end,2), annotationData(a, 2));
                            newAnnotation(end, 3) = min(newAnnotation(end, 3), annotationData(a, 3));
                        else
                            % no overlap
                            newAnnotation(end+1, :) = annotationData(a, :);
                        end
                    end
                    % now save the merged annotation
                    % first delete the old annotations
                    keepRows = setdiff(1:size(classificationResult.(superClassesNames{runs(r)}), 1), rows);
                    classificationResult.(superClassesNames{runs(r)}) = classificationResult.(superClassesNames{runs(r)})(keepRows, :);
                    %then add the new ones
                    for a=1:size(newAnnotation,1)
                        thisRunStart = newAnnotation(a,1);
                        thisRunEnd = newAnnotation(a,2);
                        thisRunStartInDocument = thisRunStart - files_frame_start(currentDocument)+1;
                        thisRunEndInDocument = thisRunEnd - files_frame_start(currentDocument)+1;
                        newCost = newAnnotation(a,3);
                        
                         classificationResult.(superClassesNames{runs(r)}) = ...
                            [classificationResult.(superClassesNames{runs(r)}); ...
                             currentDocument, thisRunStartInDocument, thisRunEndInDocument, thisRunStart, thisRunEnd, newCost];
                    end
                        
%                     % the hits overlap (end frame of the last hit is greater than
%                     % the start frame of this hit.
%                     % then merge both classifications
%                     if (classificationResult.(superClassesNames{runs(r)})(end,[4]) > thisRunEnd)
%                         disp('error');
%                     end
%                     classificationResult.(superClassesNames{runs(r)})(end,[3,5]) = [thisRunEndInDocument, thisRunEnd];
%                     classificationResult.(superClassesNames{runs(r)})(end,6) = min(classificationResult.(superClassesNames{runs(r)})(end,6), cost);

                else
                    classificationResult.(superClassesNames{runs(r)}) = ...
                    [classificationResult.(superClassesNames{runs(r)}); ...
                     currentDocument, thisRunStartInDocument, thisRunEndInDocument, thisRunStart, thisRunEnd, cost];
                end
                currentDocument = currentDocument + 1 ;
            end
        end
%         
%         thisRunStartInDocument = thisRunStart - files_frame_start(currentDocument)+1;
%         thisRunEndInDocument = thisRunEnd - files_frame_start(currentDocument)+1;
%         
%         % save the found hit in the classificationResults-variable
%         % take care of overlapping classifications
%         if ~isempty(classificationResult.(superClassesNames{runs(r)})) && ...
%             ((classificationResult.(superClassesNames{runs(r)})(end,5) >=  thisRunStart))
%             % the hits overlap (end frame of the last hit is greater than
%             % the start frame of this hit.
%             % then merge both classifications
%             classificationResult.(superClassesNames{runs(r)})(end,[3,5]) = [thisRunEndInDocument, thisRunEnd];
%             classificationResult.(superClassesNames{runs(r)})(end,6) = min(classificationResult.(superClassesNames{runs(r)})(end,6), cost);
% 
%         else
%             classificationResult.(superClassesNames{runs(r)}) = ...
%             [classificationResult.(superClassesNames{runs(r)}); ...
%              currentDocument, thisRunStartInDocument, thisRunEndInDocument, thisRunStart, thisRunEnd, cost];
%         end
        
%         color = interpolateColors(classColors(runs(r),:), [0.9 0.9 0.9], 0, classDependentThreshold(runs(r)), cost);
%         rect = rectangle('Position', [thisRunStart, runs(r)-0.3,...
%             thisRunEnd - thisRunStart , 0.6],...
%             'EdgeColor', color,...     %(1-(classificationDelta(runs(r), thisRunEnd))/max_thresh) * classColors(runs(r),:), ...
%             'FaceColor', color,...     %(1-(classificationDelta(runs(r), thisRunEnd))/max_thresh) * classColors(runs(r),:),...
%             'LineWidth', 1);
%         
% 
%         set(rect,'ButtonDownFcn',{@animateRectOnClick,...
%                                     DB_concat.files_name{currentDocument},...
%                                     animationStart,...
%                                     animationEnd, ...
%                                     cost
%                                   });
                              
        
        
    end
end

% set(gca, 'ytick', 1:numMotionClasses);
% set(gca, 'yticklabel', ylabels);
% columnsNaN = find(isnan(DB_concat.features(1,:)));
% height = length(motion_classes);
% for k=1:size(columnsNaN, 2)
% 
%     line('XData', [columnsNaN(1,k) columnsNaN(1,k)],...
%                        'YData', [1 height], ...
%                        'Color', 'red',...
%                        'LineWidth', 1);
% end
% 
% rectanglePositions = floor(linspace(0, DB_concat.files_frame_end(end), 11));
% for c=1:length(motion_classes)
%     for i=1:10
%         color = interpolateColors(classColors(c,:), [0.9 0.9 0.9], 0, classDependentThreshold(c), (i-1)/10*classDependentThreshold(c));
%          rectangle('Position', [rectanglePositions(i), c-0.5, ...
%             rectanglePositions(i+1)-rectanglePositions(i)-1 , 0.1],...
%             'EdgeColor', color,...     %(1-(classificationDelta(runs(r), thisRunEnd))/max_thresh) * classColors(runs(r),:), ...
%             'FaceColor', color,...     %(1-(classificationDelta(runs(r), thisRunEnd))/max_thresh) * classColors(runs(r),:),...
%             'LineWidth', 1);
% 
%         text(rectanglePositions(i), c-0.6, [num2str((i-1)/10*classDependentThreshold(c)) '  to ... ']);
%         
%     end    
% end
