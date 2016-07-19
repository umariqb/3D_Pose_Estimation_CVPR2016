function visSuperclassAnnotation(annotationDB, annotation, docIndices, parameter)
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
%   annotation
%   docIDs
%   parameter.superclasses = {}: 
%       cell arrray of strings. Defines the superclasses
%       that should be used visualize the annotaion result
%   parameter.feature_set: some valid feature-set, used to load the
%       DB_concat
%   parameter.manualAnnotationFunction = 'manualClassificationTiny'
%       set this to the function name which returns the ground truth manual 
%       annotation of the annotationDB. This is only valid if a
%       visualization should be done. 
%   parameter.countingPR =[]: set this to the countingPR cost measure
%       calculated by evaluateClassification if you want these values to be
%       visualized for each drawn document.
%   parameter.framewisePR =[]: set this to the framewisePR cost measure
%       calculated by evaluateClassification if you want these values to be
%       visualized for each drawn document.



if nargin<3
   error('Please specify input data');
end

if nargin<4
   parameter=[]; 
end


if ~isempty(parameter.manualAnnotationFunction)
    maualAnnotationFunction = str2func(parameter.manualAnnotationFunction);
    manualClassificationResult = maualAnnotationFunction();
else
    manualClassificationResult=struct('filename', []);
end

if isfield(parameter,'superclasses')==0
   parameter.superclasses = {...
       'neutral',...
       'tpose',...
       'move',...
       'sit',...
       'standUp',...
       'hop1leg',...
       'jump',...
       'kick',...
       'punch',...
       'rotateArms',...
       'throwR',...
       'grabDepositR',...
       'cartwheel',...
       'exercise'};
end

if isfield(parameter,'countingPR')==0
   parameter.countingPR = [];
end
if isfield(parameter,'framewisePR')==0
   parameter.framewisePR = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


downsampling_fac = 4;
DB_concat = DB_index_load(annotationDB, parameter.feature_set, downsampling_fac);

classesPerDocument = repmat({ fliplr(parameter.superclasses) }, 1, length(docIndices));

parameter.printFigure = false;
drawClassificationComparison(DB_concat, annotation, manualClassificationResult, docIndices, classesPerDocument, parameter)
