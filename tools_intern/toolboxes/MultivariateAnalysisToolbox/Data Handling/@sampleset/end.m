function endval = end(ss,k,n)   %#ok

% END end keyword
% -------------------
% idx = end(ss, k, n)
% -------------------
% Description: implements the end keyword for the VARIABLE class.
% Input:       {ss} sampleset instance.
%              {k} index location where the end syntax was used.
%              {n} total number of indices.
% Output:      {endval} the index corresponding to end.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 20-Sep-2004

% Let {ss} be a {p}-dimensional array of samplesets. Then, {ss} may be
% called with up to {p}+1 indices, with the first {p} locating the specific
% subarray of instance(s) in the sampleset array, and the last one refers
% to the samples within this specific subarray. Naturally, END is not
% defined in the case that the aforementioned subarray contain samplesets
% with different number of samples. In that case, this subroutine returns
% the value zero, which is later go through specific process in SUBSREF.

% find {p}
p = nodims(ss);

% associate {endval} with the appropriate value
if k <= p                   % end required for one of the first {p} indices
    if p ==1
        endval = length(ss);
    else
        endval = size(ss,k);
    end
elseif p == 0               % end required for the {p}+1'th index - scalar case
    endval = ss.no_samples;
else                        % end required for the {p}+1'th index - nonscalar case
    endval = 0;
end