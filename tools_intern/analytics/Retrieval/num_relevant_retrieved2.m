function n = num_relevant_retrieved(Q_category,hits,I_relevant,varargin)
% n = num_relevant_retrieved(Q_category,hits,I_relevant,DB_info)

if (nargin>3)
    DB_info = varargin{1};
else
    load HDM_Training_DB_info
    DB_info = info;
    clear info;
end
    
motions_relevant_incomplete = {DB_info(I_relevant).amcname}';
numReps_relevant = [DB_info(I_relevant).numReps]';
% add dummy files for multiple repetitions of a motion
motions_relevant = cell(sum(numReps_relevant),1);
p = 1;
for k=1:length(numReps_relevant)
    for j=1:numReps_relevant(k)
        motions_relevant{p} = [motions_relevant_incomplete{k} '_' num2str(j)];
        p = p+1;
    end
end

h = [hits.info];
motions_retrieved = {h.amcname}';
n_motretrieved = length(motions_retrieved);
% find multiple hits, convert them to dummy files
[motions_retrieved_sorted, sortIdx] = sort(motions_retrieved);
[Y, sortBackIdx] = sort(sortIdx);

pos = 1;
while (pos<=n_motretrieved)
    count = 1;
    motions_retrieved{pos} = [motions_retrieved_sorted{pos} '_' num2str(count)];
    pos = pos+1;
    while (pos<=n_motretrieved & strcmp(motions_retrieved_sorted{pos},motions_retrieved_sorted{pos-1}))
        count = count+1;
        motions_retrieved{pos} = [motions_retrieved_sorted{pos} '_' num2str(count)];
        pos = pos+1;
    end
end

motions_retrieved = motions_retrieved(sortBackIdx);

n = zeros(1,length(hits));
for k=1:length(hits)
    [motions_relret,I_relret,I_retrel] = intersect(upper(motions_relevant),upper(motions_retrieved(1:k)));
    %missing = setdiff(motions_relevant,motions_retrieved(1:k));
    
    if (~isempty(motions_relret))
        n(k) = length(motions_relret);
    end
end
