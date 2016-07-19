function endval = end(gr,k,n)

% END end keyword
% -------------------
% idx = end(gr, k, n)
% -------------------
% Description: implements the end keyword for the GROUPING class.
% Input:       {gr} group instance.
%              {k} index location where the end syntax was used.
%              {n} total number of indices.
% Output:      {endval} the index corresponding to end.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 15-Jun-2004

% Let {gr} be a {p}-dimensional array of groupings. Then, {gr} may be
% called with up to {p}+2 indices, with the first {p} locating the specific
% subarray of instance(s) in the grouping array, and the last one refers to
% the samples within this specific subarray. Naturally, END is not defined in
% the case that the aforementioned subarray contain variables with
% different number of samples. In that case, this subroutine returns the
% value zero, which is later go through specific process in SUBSREF.

% find {p}
p = nodims(gr);

% associate {endval} with the appropriate value
if k <= p                   % end required for one of the first {p} indices
    if p == 1
        endval = length(gr);
    else
        endval = size(gr,k);
    end
elseif p == 0               % end required for the {p}+1'th index - scalar case
    endval = size(gr.assignment,k-n+2);
else                        % end required for the {p}+1'th index - nonscalar case
    endval = 0;
end