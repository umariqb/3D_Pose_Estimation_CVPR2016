function [tr, list] = subtree(tr,node)

% SUBTREE isolates the subtree branching from a certain node.
% -----------------------------
% [tr list] = subtree(tr, node)
% -----------------------------
% Description: isolates the subtree branching from a certain node.
% Input:       {tr} bintree instance.
%              {node} the node to be the root of the new tree.
% Output:      {tr} new bintree.
%              {list} list of nodes that remain in the subree.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 03-Sep-2004

% update tree
[tr.tree list] = subtree(tr.tree,node);

% update l_node
l_node = tr.l_node(list);
for ii = 1:length(list)
    nd = list(ii);
    l_node(l_node==nd) = ii;
end
tr.l_node = l_node;

% update r_node
r_node = tr.r_node(list);
for ii = 1:length(list)
    nd = list(ii);
    r_node(r_node==nd) = ii;
end
tr.r_node = r_node;