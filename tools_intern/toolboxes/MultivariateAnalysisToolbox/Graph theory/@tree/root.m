function node = root(tr)

% ROOT finds the root of the tree.
% ---------------
% node = root(tr)
% ---------------
% Description: find the root of the tree.
% Input:       {tr} tree instance.
% Output:      {node} ID of the root node.

% © Liran Carmel
% Classification: Tree structure
% Last revision date: 20-Apr-2004

node = find(~tr.parent);