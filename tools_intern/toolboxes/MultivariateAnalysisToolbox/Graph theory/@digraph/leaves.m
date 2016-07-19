function nodes = leaves(dg)

% LEAVES finds these nodes that are leaves.
% ------------------
% nodes = leaves(dg)
% ------------------
% Description: finds these nodes that are leaves.
% Input:       {dg} DIGRAPH instance.
% Output:      {nodes} ID of leaf nodes.

% © Liran Carmel
% Classification: Tree structure
% Last revision date: 17-Jan-2008

% the strategy is to find all those nodes that have zero out-degree
deg = iodegree(dg);
nodes = find(deg(2,:)==0);