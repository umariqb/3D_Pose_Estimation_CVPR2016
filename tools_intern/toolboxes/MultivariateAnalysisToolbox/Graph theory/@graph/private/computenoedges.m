function no_edges = computenoedges(W)

% COMPUTENOEDGES computes the number of edges from the weights matrix.
% ----------------------------
% no_edges = computenoedges(W)
% ----------------------------
% Description: computes the number of edges from the weights matrix.
% Input:       {W} weight matrix.
% Output:      {no_edges} number of edges in the graph.

% © Liran Carmel
% Classification: Computations
% Last revision date: 03-Dec-2004

no_self_edges = length(find(diag(W)));
no_edges = 0.5*length(find(W)) - 0.5*no_self_edges;