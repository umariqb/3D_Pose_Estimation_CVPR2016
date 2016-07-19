function deg = iodegree(dg)

% DEGREE computes the in and out degrees of a digraph.
% ------------------
% deg = iodegree(dg)
% ------------------
% Description: computes the in and out degrees of a digraph.
% Input:       {dg} DIGRAPH instance.
% Output:      {deg} matrix of size 2-by-{no_nodes}, with the first row
%                   being the in-degree, and the second being the
%                   out-degree.

% © Liran Carmel
% Classification: Computations
% Last revision date: 17-Jan-2008

% initialize
no_nodes = nonodes(dg);
deg = zeros(2,no_nodes);

% get information
D = get(dg,'thd');
W = get(dg,'weights');

% loop on all nodes
for node = 1:no_nodes
    deg(1,node) = sum(W(node,D(node,:)<0));
    deg(2,node) = sum(W(node,D(node,:)>0));
end