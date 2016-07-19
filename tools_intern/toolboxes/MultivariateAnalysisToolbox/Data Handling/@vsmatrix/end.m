function endval = end(vsm,k,n)   %#ok

% END end keyword
% --------------------
% idx = end(vsm, k, n)
% --------------------
% Description: implements the end keyword for the VSMATRIX class.
% Input:       {vsm} vsmatrix instance.
%              {k} index location where the end syntax was used.
%              {n} total number of indices.
% Output:      {endval} the index corresponding to end.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 06-Jan-2005

% Let {vsm} be a {p}-dimensional array of vsmatrices. Then, {vsm} may be
% called with up to {p}+2 indices, with the first {p} locating the specific
% vsmatrix element, and the last one refers to the samples within this
% specific element.

% find {p}
p = nodims(vsm);

% associate {endval} with the appropriate value
if k <= p       % end required to locate datamatrix element
    endval = size(vsm,k);
elseif p == 0   % end required to index datamatrix element - scalar case
    if k == 1
        endval = vsm.datamatrix.no_rows;
    else
        endval = vsm.datamatrix.no_cols;
    end
else            % end required to index datamatrix element - nonscalar case
    endval = 0;
end