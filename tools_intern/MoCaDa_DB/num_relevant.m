function [n,I] = num_relevant(Q_category,varargin)
% [n,I] = num_relevant(Q_category,restrict_to_query_skeleton,DB_info)

if (nargin>2)
    DB_info = varargin{2};
else
    info = [];
    load HDM_Training_DB_info
    DB_info = info;
    clear info;
end

restrict_to_query_skeleton = false;
if (nargin>1)
    restrict_to_query_skeleton = varargin{1};
end
    
motionClasses_DB = {DB_info.motionClass}';
numReps_DB = [DB_info.numReps]';

[numReps_Q,motionClass_Q] = motion_category_get_numreps(Q_category);

I = strmatch(motionClass_Q,motionClasses_DB,'exact');
if (isempty(I))
    n = 0;
    return;
end
if (restrict_to_query_skeleton)
    skeletonIDs_DB = {DB_info.skeletonID}';
    skeletonID_Q = Q_info.skeletonID;
    J = strmatch(skeletonID_Q,skeletonIDs_DB,'exact');
    I = C_intersect_presorted(I,J);
end

h = numReps_DB(I);
I = I(h>=numReps_Q);
h = h(h>=numReps_Q);
n = sum(h-numReps_Q+1);
