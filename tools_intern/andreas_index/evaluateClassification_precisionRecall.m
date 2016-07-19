function annotationCost = evaluateClassification_precisionRecall(classes, groundTruthAnnotations, computedAnnotations, parameter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: evaluateClassification_precisionRecall
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

if isfield(parameter,'documentComputedAnnotationLength')==0 || isfield(parameter,'documentManualAnnotationLength')==0
   parameter.documentComputedAnnotationLength = 1;
   parameter.documentManualAnnotationLength = 1;
   disp('Warning: Using unnormalized results in evaluateClassification_precisionRecall because parameter.documentComputedAnnotationLength or parameter.documentManualAnnotationLength is not set.');
end



if isfield(parameter,'vis')==0
   parameter.vis = 0;
end

    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
matchedGroundTruthFrames = 0;
annotationCost = zeros(1,2);

 for c=1:length(classes)
    for a=1:size(groundTruthAnnotations{c,1})
        matchedAnnotation = groundTruthAnnotations{c,2}{a};
        matchedGroundTruthFrames = matchedGroundTruthFrames + length(matchedAnnotation);
    end
 end

% precision: number of found documents (= matched ground truth frames)
% by number of found documents
% (= documentComputedAnnotationLength)
if matchedGroundTruthFrames == 0
    % this is the case if no manual annotation occured or
    % if no computed annotation occured or
    % if no overlap between the computed annotation and the
    % manual annotation occured.
    % 
    annotationCost(1, 1) = 0;
else 
    annotationCost(1, 1) = matchedGroundTruthFrames / parameter.documentComputedAnnotationLength;
end

% recall: number of found documents (= matched ground truth frames)
% by number of relevant documents 
% (= documentManualAnnotationLength)
if matchedGroundTruthFrames == 0
    % this is the case if no manual annotation occured or
    % if no computed annotation occured or
    % if no overlap between the computed annotation and the
    % manual annotation occured.
    % 
    annotationCost(1, 2) = 0;
else 
    annotationCost(1, 2) = matchedGroundTruthFrames / parameter.documentManualAnnotationLength;
end