% FUNCTION SUBSETS_ALL: compute all subsets of a given set.
% 
% subsets = subsets_all(set, max_subset_size) enerates all possible 
% subsets of the parameter set. 
% Set has to be an (1xN) cell array containing set elements.
% Returned is a cell array subsets which contains all subsets 
% of set. Each subset is again encapsulated in an one-row cell array.
% If max_subset_size is set only subsets of the length 1:max_subset_size
% are computed.

function subsets = subsets_all(set, max_subset_size)
if (nargin < 2)
    max_subset_size = length(set);
end

subsets=cell(1,1);
count = 1;
for k=1:min(length(set), max_subset_size)
    combis=nchoosek(set, k);
    [num_combis,num_elements_per_combi]=size(combis);
    for l=1:num_combis
        combi=cell(1,num_elements_per_combi);
        for m=1:num_elements_per_combi
            combi{1,m}=combis{l,m};
        end
        subsets{1,count}= combi;
        count = count+1;
    end
end
