function nodes = vstruct(dg)

% VSTRUCT finds nodes that are center of a V-structure.
% -------------------
% nodes = vstruct(dg)
% -------------------
% Description: finds nodes that are center of a V-structure. The nodes are
%              returned sorted (by node ID). If a node is a center to k
%              V-structures, it will appear in {nodes} k times.
% Input:       {dg} instance of DIGRAPH.
% Output:      {nodes} list of nodes that are center of a V-structure.

% © Liran Carmel
% Classification: Computations
% Last revision date: 26-Mar-2008

% initialize
nodes = [];

% find all nodes with indegree > 1
deg = iodegree(dg);
idx = find(deg(1,:) > 1);

% substitute in {nodes}
for ii = idx
    mult = nchoosek(deg(1,ii),2);
    nodes = [nodes ii*ones(1,mult)];
end

% sort and return
nodes = sort(nodes);