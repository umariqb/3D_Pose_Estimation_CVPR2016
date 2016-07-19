function nodes = leaves(tr)

% LEAVES finds these nodes that are leaves.
% ------------------
% nodes = leaves(tr)
% ------------------
% Description: finds these leaves that are leaves.
% Input:       {tr} tree instance.
% Output:      {nodes} ID of leaf nodes.

% © Liran Carmel
% Classification: Tree structure
% Last revision date: 21-Apr-2004

% the strategy is to find all those nodes that are not the parent of any
% other node.
par = tr.parent;
par(root(tr)) = [];
par = unique(par);
nodes = allbut(par,get(tr,'no_nodes'));