function [annotationCost, varargout]= evaluateClassification(files_name, files_frame_length, classificationResult, manualAnnotation, parameter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: evaluateClassification
% Version: 1
% Date: 12.08.2008
% Programmer: Andreas Baak
%
% Description: 
%
% Input:  
%         files_name: cell arrray of filenames that directly correspond to
%         the file indices in classificationResult
%         files_frame_length: vector of file lengths (30Hz) which directly
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
%         parameter.evaluationMethod = 'tolerantMatch' (default)
%                                      'framewisePR'
%                                      'counting'           
%                                      'countingPR'
%                                      'all'
%         parameter.displayCost: prints information about the cost of every
%                                part in the document
%         
%         parameter.docNr_to_manualAnnotationNr
%
% Output: 
%         annotationCost: cost vector, cost for each file in files_name
% classification. 
%         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<4
   error('Please specify input data');
end

if nargin<5
   parameter=[]; 
end

if isfield(parameter,'evaluationMethod')==0
     parameter.evaluationMethod = 'tolerantMatch';
end

if isfield(parameter,'displayCost')==0
   parameter.displayCost = 0;
end
if isfield(parameter,'docNr_to_manualAnnotationNr')==0
   parameter.docNr_to_manualAnnotationNr = [];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


classes = fieldnames(classificationResult);

switch lower(parameter.evaluationMethod)
    case 'tolerantmatch' 
        annotationCost = zeros(length(files_name), 1);
    case 'framewisepr'
        annotationCost = zeros(length(files_name), 2); %first column: precision, second: recall
    case 'counting'
        annotationCost = zeros(length(files_name), 1);
    case 'countingpr'
        annotationCost = zeros(length(files_name), 2); %first column: precision, second: recall
    case 'all'
        annotationCost = zeros(length(files_name), 1); % tolerantMatch
        varargout = cell(1,2);
        varargout{1} = zeros(length(files_name), 2); %precisionrecall
        varargout{2} = zeros(length(files_name), 1); %counting    
        varargout{3} = zeros(length(files_name), 2); %countingPR    
    otherwise
        error (['Evaluation method  ' parameter.evaluationMethod ' unknown.']);
end
for d=1:length(files_name)
    %currentDocument = documents(d);
    docName = files_name{d};
    %idx = strfind(docName, filesep);
    %docShortName = docName((idx(end)+1):end-4);
    
    docLength = files_frame_length(d);

    %gather manual annotations
    if isempty(parameter.docNr_to_manualAnnotationNr)
        annotationIdx = strmatch(docName, {manualAnnotation.filename});
    else
        annotationIdx = parameter.docNr_to_manualAnnotationNr(d);
    end
    if length(annotationIdx) > 1
        error(['More than one manual annotation found for document' num2str(d) ': ' docName]);
    end
    if isempty(annotationIdx) ||  annotationIdx == 0
        disp(['WARNING: No manual annotation found for document ' num2str(d) ': ' docName]);
        continue;
    end
    annotations = manualAnnotation(annotationIdx);
    
    % first column:  a matrix that depicts the start- and endframes of the annotation
    % second column: a matrix that for each annotation depicts which frames
    %                have been matched correctly.
    groundTruthAnnotations = cell(length(classes), 2);
    manualAnnotatedClasses = fieldnames(annotations.classInfo);
    documentManualAnnotationLength = 0;
    for g=1:length(manualAnnotatedClasses)
        %which index in the classes list does the classInfo belong to?
        idx = strmatch(manualAnnotatedClasses{g}, classes);
        thisAnnotation = ceil(annotations.classification{annotations.classInfo.(manualAnnotatedClasses{g})}/4);
        if ~isempty(idx)
            groundTruthAnnotations{idx, 1} = cell(size(thisAnnotation,1), 1);
            for i=1:size(thisAnnotation,1)
                groundTruthAnnotations{idx, 1}{i} = thisAnnotation(i,1):thisAnnotation(i,2);
                documentManualAnnotationLength = documentManualAnnotationLength + thisAnnotation(i,2)-thisAnnotation(i,1)+1;
            end
        end
%         
%         groundTruthAnnotations{idx, 1} = reshape(annotations.classification{annotations.classInfo.(manualAnnotatedClasses{g})}, 2, [])';
%         for i=1:size(groundTruthAnnotations{idx, 1}, 1)
%             groundTruthAnnotations{idx, 1} = groundTruthAnnotations{idx, 1}(i,1):groundTruthAnnotations{idx, 1}(i,2);
%         end
    end
    
    % if there is NO manual annotation, then set the
    % documentManualAnnotationLength to the docLength so that all annotation cost
    % will be normalized by the document length.
    if documentManualAnnotationLength == 0
        documentManualAnnotationLength = docLength;
    end
    
    documentComputedAnnotationLength = 0;
    computedAnnotations = cell(length(classes), 2);
    %gather computed annotations
    for c=1:length(classes)
        class = classes{c};
        thisClassificationResult = classificationResult.(class);
        thisAnnotation = [];
        if ~isempty(thisClassificationResult)
            thisAnnotation = classificationResult.(class)((thisClassificationResult(:,1) == d), [2:3]);
        end
        computedAnnotations{c, 1} = cell(size(thisAnnotation, 1),1);
        for i=1:size(thisAnnotation,1)
            computedAnnotations{c, 1}{i} = thisAnnotation(i,1):thisAnnotation(i,2);
            documentComputedAnnotationLength = documentComputedAnnotationLength + thisAnnotation(i,2)-thisAnnotation(i,1)+1;
        end
%         computedAnnotations{c, 1} = classificationResult.(class)((classificationResult.(class)(:,1) == currentDocument), [2:3]);
    end
    
    
        
    % process the annotations, mark, which parts of the annotations are
    % good. -> save good parts in the second column of
    % groundTruthAnnotations and computedAnnotations.
    for c=1:length(classes)
        computedClassAnnotation = computedAnnotations{c, 1};
        computedAnnotations{c, 2} = cell(size(computedClassAnnotation,1), 1);
        
        groundTruthClassAnnotation = groundTruthAnnotations{c,1};
        groundTruthAnnotations{c,2} = cell(size(groundTruthClassAnnotation, 1), 1);

        for a=1:size(computedClassAnnotation, 1)
            singleComputedClassAnnotation = computedClassAnnotation{a};
            % now check if the annotation intersects 
            for g=1:size(groundTruthClassAnnotation, 1)
                intersection = intersect(singleComputedClassAnnotation, groundTruthClassAnnotation{g});
                if isempty(groundTruthAnnotations{c,2}{g})
                    groundTruthAnnotations{c,2}{g} = intersection;
                else
                    groundTruthAnnotations{c,2}{g} = [groundTruthAnnotations{c,2}{g} intersection];
                end
                
                if isempty(computedAnnotations{c, 2}{a})
                    computedAnnotations{c, 2}{a} = intersection;
                else
                    computedAnnotations{c, 2}{a} = [computedAnnotations{c, 2}{a} intersection];
                end
            end           
        end
    end
    
    % now calculate the cost for the annotations
    parameter.docLength = docLength;
    parameter.documentComputedAnnotationLength = documentComputedAnnotationLength;
    parameter.documentManualAnnotationLength = documentManualAnnotationLength;
    
    switch lower(parameter.evaluationMethod)
        case 'tolerantmatch' 
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Tolerant match   %%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            annotationCost(d, :) = evaluateClassification_tolerantMatch(classes, groundTruthAnnotations, computedAnnotations, parameter);

        case 'framewisepr'
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Precision/Recall %%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            annotationCost(d, :) = evaluateClassification_precisionRecall(classes, groundTruthAnnotations, computedAnnotations, parameter);
            
       

        case 'counting'
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Counting         %%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            annotationCost(d, :) = evaluateClassification_counting(classes, groundTruthAnnotations, computedAnnotations, parameter);

        case 'countingpr'
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Counting         %%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            annotationCost(d, :) = evaluateClassification_countingPR(classes, groundTruthAnnotations, computedAnnotations, parameter);

        
        case 'all'
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Counting         %%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
            if parameter.displayCost == 1
                fprintf('Cost values for document %i:\n' , d);
            end
            annotationCost(d, :) = evaluateClassification_tolerantMatch(classes, groundTruthAnnotations, computedAnnotations, parameter);
            varargout{1}(d,:) = evaluateClassification_precisionRecall(classes, groundTruthAnnotations, computedAnnotations, parameter);
            varargout{2}(d,:) = evaluateClassification_counting(classes, groundTruthAnnotations, computedAnnotations, parameter);
            varargout{3}(d, :) = evaluateClassification_countingPR(classes, groundTruthAnnotations, computedAnnotations, parameter);
        otherwise
            error('Some error occured in the selection of the evaluation method.');
        
    end %switch evaluationMethod

end %for all files
    
    