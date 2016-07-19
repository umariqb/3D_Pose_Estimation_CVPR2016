function [combinedDelta, superClassesNames] = combineDelta(delta, deltaClasses, classDefinition, parameter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: combineDelta
% Version: 1
% Date: 07.08.2008
% Programmer: Andreas Baak
%
% Description: Unifies the subclass level delta functions to a superclass
% level by minimization over all subclass deltas in a superclass.
%
% Input:  
%              delta: CxN matrix, contatains distance values for C
%                     subclasses and a database of N frames. 
%              deltaClasses: Cx1 cell arrray of strings, describes which
%              row of delta belongs to which motion class.
%              classDefinition: struct that describes which subclasses
%              should be unified to a superclass.
%
%         parameter.outputProgress = false
%         
%
% Output: 
%         combinedDelta
%         superClassesNames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<4
   parameter=[]; 
end
if isfield(parameter, 'outputProgress') == 0
    parameter.outputProgress =false;
end
if nargin<3
   error('Please specify input data');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nframes = size(delta, 2);
superClassesNames = fieldnames(classDefinition);
numSuperClasses  = length(superClassesNames);
combinedDelta = inf(numSuperClasses, nframes);

% build the combined delta delta for all defined superclasses.
% for that task, the classification delta of the corresponding subclasses
% are minimized.
for c=1:numSuperClasses
    if parameter.outputProgress 
        disp(['Combining deltas for superclass ' superClassesNames{c}]);
    end
    subClasses = classDefinition.(superClassesNames{c});
    subClassesIndices = zeros(1, length(subClasses));
    for s=1:length(subClasses)
        idx = strmatch(subClasses{s}, (deltaClasses), 'exact');
        if isempty(idx) || idx < 1
            error(['Subclass ' subClasses{s} ' not found in classification delta classes names!']);
        end
        if length(idx) > 1
            error(['Subclass ' subClasses{s} ' found found multiple times in classification delta classes names!']);
        end
        subClassesIndices(s) = idx;
    end
    combinedDelta(c,:) = min(delta(subClassesIndices, :), [], 1);
end
