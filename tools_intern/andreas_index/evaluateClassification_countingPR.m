function annotationCost = evaluateClassification_countingPR(classes, groundTruthAnnotations, computedAnnotations, parameter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: evaluateClassification_countingPR
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

noMatchedGroundTruthAnnoations = 0;
noMatchedComputedAnnoations = 0;
noGroundTruthAnnotations = 0;
noComputedAnnotations = 0;
annotationCost = zeros(1,2);

for c=1:length(classes)
    noGroundTruthAnnotations = noGroundTruthAnnotations + size(groundTruthAnnotations{c,1}, 1);
    for a=1:size(groundTruthAnnotations{c,1})
        matchedAnnotation = groundTruthAnnotations{c,2}{a};
        if ~isempty(matchedAnnotation)
            noMatchedGroundTruthAnnoations = noMatchedGroundTruthAnnoations + 1;
        end 
    end
end
for c=1:length(classes)
    noComputedAnnotations = noComputedAnnotations + size(computedAnnotations{c,1}, 1);
    for a=1:size(computedAnnotations{c,1})
        matchedAnnotation = computedAnnotations{c,2}{a};
        if ~isempty(matchedAnnotation)
            noMatchedComputedAnnoations = noMatchedComputedAnnoations + 1;
        end 
    end
end


% precision: number of found ground truth annotations
% by number of found annotations
if noMatchedComputedAnnoations == 0
    % this is the case if no manual annotation occured or
    % if no computed annotation occured or
    % if no overlap between the computed annotation and the
    % manual annotation occured.
    % 
    annotationCost(1, 1) = 0;
else 
    annotationCost(1, 1) = noMatchedComputedAnnoations / noComputedAnnotations;
end

% recall: found ground truth annotations
% by number of relevant documents (number of ground truth annotations)
if noMatchedGroundTruthAnnoations == 0
    % this is the case if no manual annotation occured or
    % if no computed annotation occured or
    % if no overlap between the computed annotation and the
    % manual annotation occured.
    % 
    annotationCost(1, 2) = 0;
else 
    annotationCost(1, 2) = noMatchedGroundTruthAnnoations / noGroundTruthAnnotations;
end

