function annotationCost = evaluateClassification_tolerantMatch(classes, groundTruthAnnotations, computedAnnotations, parameter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: evaluateClassification_tolerantMatch
% Version: 1
% Date: 18.08.2008
% Programmer: Andreas Baak
%
% Description: 
%
% Input:  
%         classes:
%         groundTruthAnnotations
%         computedAnnotations
%
%         parameter.documentManualAnnotationLength 
%         
%
% Output: 
%         annotationCost
%         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<4
   parameter=[]; 
end
if nargin<3
   error('Please specify input data');
end

if isfield(parameter,'documentManualAnnotationLength')==0
   parameter.documentManualAnnotationLength = 1;
   disp('Warning: Using unnormalized results in evaluateClassification_tolerantMatch because parameter.documentManualAnnotationLength is not set.');
end


if isfield(parameter,'vis')==0
   parameter.vis = 0;
end
if isfield(parameter,'fps')==0
   parameter.fps = 30;
end

    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fps = parameter.fps;
annotationCost = 0;
for c=1:length(classes)
    for a=1:size(groundTruthAnnotations{c,1})
        annotation = groundTruthAnnotations{c,1}{a};
        matchedAnnotation = groundTruthAnnotations{c,2}{a};
        if isempty(matchedAnnotation)
            % assign full cost to the annotation
            annotationCost = annotationCost + length(annotation) / parameter.documentManualAnnotationLength;
            if parameter.displayCost == 1
                fprintf('Annotation cost unnormalized groundTruth for class %s, number %i: %.1f\n', classes{c}, a, length(annotation));
            end                    

        else
            % The annotation was matched somehow. Assign cost if the
            % annotation hasn't been matched well.
            if length(annotation)/fps < 1 % is the length of the annotation less than 1 second?
                % if less than 50% are matched, then assign cost to these 50%
                unmatched = length(annotation)*0.5 - length(matchedAnnotation);
            else
                % the annotation is longer than one second. Generally
                % allow 1/2 second mismatch, everything that has a
                % longer mismatch will be punished with some cost
                % value.
                unmatched = length(annotation) - length(matchedAnnotation) - fps*0.5;
            end
            if (unmatched > 0)
                annotationCost = annotationCost + unmatched / parameter.documentManualAnnotationLength;
                if parameter.displayCost == 1
                    fprintf('Annotation cost unnormalized  groundTruth for class %s, number %i: %f\n',  classes{c}, a, unmatched);
                end
            end
        end
    end
    for a=1:size(computedAnnotations{c,1})
        annotation = computedAnnotations{c,1}{a};
        matchedAnnotation = computedAnnotations{c,2}{a};
       if isempty(matchedAnnotation)
            % assign full cost to the annotation
            annotationCost = annotationCost + length(annotation) / parameter.documentManualAnnotationLength;
            if parameter.displayCost == 1
                fprintf('Annotation cost unnormalized compAnnot for class %s, number %i: %.1f\n', classes{c}, a, length(annotation));
            end                     
        else
            % The annotation was matched somehow. Assign cost if the
            % annotation hasn't been matched well.
            if length(annotation)/fps < 1 % is the length of the annotation less than 1 second?
                % if less than 50% are matched, then assign cost to these 50%
                unmatched = length(annotation)*0.5 - length(matchedAnnotation);
            else
                % the annotation is longer than one second. Generally
                % allow 1/2 second mismatch, everything that has a
                % longer mismatch will be punished with some cost
                % value.
                unmatched = length(annotation) - length(matchedAnnotation) - fps*0.5;
            end
            if (unmatched > 0)
                annotationCost = annotationCost + unmatched / parameter.documentManualAnnotationLength;
                if parameter.displayCost == 1
                    fprintf('Annotation cost unnormalized compAnnot for class %s, number %i: %f\n', classes{c}, a, unmatched);
                end                    
            end
        end
    end
end % for all classes