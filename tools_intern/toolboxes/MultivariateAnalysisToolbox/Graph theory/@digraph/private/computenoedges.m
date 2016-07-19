function no_edges = computenoedges(W,D)

% COMPUTENOEDGES computes the number of edges from W and D.
% -------------------------------
% no_edges = computenoedges(W, D)
% -------------------------------
% Description: computes the number of edges from the weights matrix and the
%              THD matrix.
% Input:       {W} weight matrix.
% Output:      {no_edges} number of edges in the graph.

% © Liran Carmel
% Classification: Computations
% Last revision date: 06-Dec-2004

% combine matrices
if isempty(W)       % if {W} is empty, determine # edges by {D}
    combined = D;
elseif isempty(D)   % if {D} is empty, determine # edges by {W}
    combined = W;
elseif all(size(W)==size(D))    % determine # edges by both {D} and {W}
    combined = (W ~= 0) | (D ~= 0);
else     % {W} and {D} do not match in size. This can happen in the middle of a set sequence
    no_edges = 0;
    return;
end

% compute no_edges
no_self_edges = length(find(diag(combined)));
no_edges = 0.5*length(find(combined)) - 0.5*no_self_edges;