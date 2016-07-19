function annotationCost = evaluateClassification_counting(classes, groundTruthAnnotations, computedAnnotations, parameter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: evaluateClassification_counting
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
%         parameter.docLength = docLength;
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

if isfield(parameter,'docLength')==0
   parameter.docLength = 1;
   disp('Warning: Using unnormalized results in evaluateClassification_counting because parameter.docLength is not set.');
end


if isfield(parameter,'docLength')==0
   parameter.docLength = 0;
end

if isfield(parameter,'vis')==0
   parameter.vis = 0;
end

    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
annotationCost = 0;
for c=1:length(classes)
    for a=1:size(groundTruthAnnotations{c,1})
        annotation = groundTruthAnnotations{c,1}{a};
        matchedAnnotation = groundTruthAnnotations{c,2}{a};
        if isempty(matchedAnnotation)
            annotationCost = annotationCost + length(annotation)/parameter.docLength;
        end
    end
    for a=1:size(computedAnnotations{c,1})
        annotation = computedAnnotations{c,1}{a};                    
        matchedAnnotation = computedAnnotations{c,2}{a};
        if isempty(matchedAnnotation)
            annotationCost = annotationCost + length(annotation)/parameter.docLength;
        end
    end
end % for all classes
