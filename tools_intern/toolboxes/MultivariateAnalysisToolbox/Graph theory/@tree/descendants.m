function list = descendants(tr,node)

% DESCENDANTS finds all descandants of a specifed node.
% ----------------------------
% list = descendants(tr, node)
% ----------------------------
% Description: finds all descandants of a specifed node.
% Input:       {tr} tree instance.
%              {node} the node to compute the descendants of (index or
%                   name). 
% Output:      {list} list of nodes that remain in the subree.

% © Liran Carmel
% Classification: Tree structure
% Last revision date: 29-Jan-2008

% parse input
if ischar(node)
    node = name2idx(tr,node);
end

% return in a trivial case
if node == root(tr)
    list = 1:get(tr,'no_nodes');
    return;
end

% extract information
pa = get(tr,'parent');

% initialize
list = node;  % list of nodes to be included in the new tree

% recursively find children of {node}
to_update = find(pa==node);
list = [list to_update];
while ~isempty(to_update)
    nodeID = to_update(1);
    to_add = find(pa==nodeID);
    list = [list to_add];
    to_update = [to_update to_add];
    to_update(1) = [];
end
list = sort(list);