function endval = end(vvm,k,n)

% END end keyword
% --------------------
% idx = end(vvm, k, n)
% --------------------
% Description: implements the end keyword for the VVMATRIX class.
% Input:       {vvm} vvmatrix instance.
%              {k} index location where the end syntax was used.
%              {n} total number of indices.
% Output:      {endval} the index corresponding to end.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 02-Sep-2004

% Let {vvm} be a {p}-dimensional array of vvmatrices. Then, {vvm} may be
% called with up to {p}+2 indices, with the first {p} locating a specific
% instance in the array, and the last two index this instance.

% find {p}
p = nodims(vvm);

% associate {endval} with the appropriate value
if k <= p                   % end required for one of the first {p} indices
    if p == 1
        endval = length(vvm);
    else
        endval = size(vvm,k);
    end
elseif p == 0               % end required for the matrix indexing - scalar case
    if n == 2
        endval = size(vvm.matrix,k);
    else
        endval = numel(vvm.matrix);
    end
else                        % end required for the {p}+1'th index - nonscalar case
    endval = 0;
end