function endval = end(ds,k,n)   %#ok

% END end keyword
% -------------------
% idx = end(ds, k, n)
% -------------------
% Description: implements the end keyword for the DATASET class.
% Input:       {ds} dataset instance.
%              {k} index location where the end syntax was used.
%              {n} total number of indices.
% Output:      {endval} the index corresponding to end.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 18-Feb-2004

endval = size(ds,k);