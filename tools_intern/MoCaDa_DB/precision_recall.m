function [precision,recall] = precision_recall(Q_category,hits,varargin)

if (nargin>3)
    DB_info = varargin{2};
else
    info = [];
    load HDM_Training_DB_info
    DB_info = info;
    clear info;
end

if strfind(upper(hits(1).file_name), '.C3D')
    % "convert" filenames to AMC
    for i=1:length(hits)
        hits(i).file_name = lower(strrep(upper(hits(i).file_name), '.C3D', '.AMC'));
        hits(i).info.amcname = lower(strrep(upper(hits(i).info.amcname), '.C3D', '.AMC'));
    end
end

restrict_to_query_skeleton = false;
if (nargin>2)
    restrict_to_query_skeleton = varargin{1};
end

n_retrieved = [1:length(hits)];
[n_relevant,I_relevant] = num_relevant(Q_category,restrict_to_query_skeleton,DB_info);
n_relevant_retrieved = num_relevant_retrieved(Q_category,hits,I_relevant,DB_info);

precision = n_relevant_retrieved ./ n_retrieved;
recall = n_relevant_retrieved / n_relevant;