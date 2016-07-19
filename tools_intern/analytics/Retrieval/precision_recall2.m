function [precision,recall, n_relevant] = precision_recall2( Q_category, hits, restrict_to_query_skeleton, DB_info, includeReps)

precision = [0];
recall = [0];
n_relevant = 0;

if length(hits) == 0
    return
end

if (nargin < 3) || isempty(restrict_to_query_skeleton)
    restrict_to_query_skeleton = false;
end

if (nargin < 4) || isempty(DB_info)
    info = [];
    load HDM_Training_DB_info
    DB_info = info;
    clear info;
end

if (nargin < 5) || isempty(includeReps)
    includeReps = true;
end

DB_name = 'HDM05_cut_amc';

if strfind(upper(hits(1).file_name), '.C3D')
    % "convert" filenames to AMC
    for i=1:length(hits)
        hits(i).file_name = lower(strrep(upper(hits(i).file_name), '.C3D', '.AMC'));
        hits(i).info.amcname = lower(strrep(upper(hits(i).info.amcname), '.C3D', '.AMC'));
    end
    DB_name = 'HDM05_cut_c3d';
end


n_retrieved = [1:length(hits)];
% [n_relevant,I_relevant] = num_relevant(Q_category,restrict_to_query_skeleton,DB_info);

[reps, catName] = motion_category_get_numreps(Q_category);
n_relevant = 0;
I_relevant = [];
catNameReps = Q_category;

if includeReps
    for i=reps:6
        %     y = getCategoryFileIndices(fullfile(DB_name, [catName num2str(i) 'Reps']), 0.5, 1);
        dbidx = intersect(strmatch(catName, {DB_info(:).motionClass},'exact'), find([DB_info(:).numReps]==i));
        
        if ~isempty(dbidx)
            y = getCategoryFileIndices(fullfile(DB_name, catNameReps), 0.5, 1);
            if y.unused ~= 0
                I_relevant = [I_relevant dbidx(y.unused)];
                n_relevant = n_relevant + (i-reps+1)*length(y.unused);
            end
        end
        catNameReps = incrementLeftmostDigit(catNameReps);
    end
else
    dbidx = intersect(strmatch(catName, {DB_info(:).motionClass},'exact'), find([DB_info(:).numReps]==reps));
    
    if ~isempty(dbidx)
        y = getCategoryFileIndices(fullfile(DB_name, catNameReps), 0.5, 1);
        if y.unused ~= 0
            I_relevant = [I_relevant dbidx(y.unused)];
            n_relevant = n_relevant + length(y.unused);
        end
    end
end
% if isempty(I_relevant)  % category name does not include "reps"
%     y = getCategoryFileIndices(fullfile(DB_name, catName), 0.5, 1);
%     dbidx = intersect(strmatch(catName, {DB_info(:).motionClass}), find([DB_info(:).numReps]==1));
%     I_relevant = [I_relevant dbidx(y.unused)];
%     n_relevant = length(y.unused);
%     end
% end

% y = getCategoryFileIndices(fullfile(DB_name, Q_category), 0.5, 1);
% I_relevant = I_relevant(y.unused);
% n_relevant = length(y.unused);

if n_relevant == 0
    precision = [0];
    recall = [0];
    return;
end

n_relevant_retrieved = num_relevant_retrieved2(Q_category,hits,I_relevant,DB_info);

precision = n_relevant_retrieved ./ n_retrieved;
recall = n_relevant_retrieved / n_relevant;