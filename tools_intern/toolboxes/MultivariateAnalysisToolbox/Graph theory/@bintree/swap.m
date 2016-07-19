function [tr, first, last] = swap(tr,node_1,node_2)

% SWAP replaces the indices of two nodes.
% ------------------------------------------
% [tr first last] = swap(tr, node_1, node_2)
% ------------------------------------------
% Description: replaces the indices of two nodes.
% Input:       {tr} bintree instance.
%              {node_1} first node.
%              {node_2} second node.
% Output:      {tr} the bintree with the two nodes replaced.
%              {first} the smallest of {node_1} and {node_2}.
%              {last} the highest of {node_1} and {node_2}.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 14-Mar-2006

% modify tree
father = tr.tree;
[father first last] = swap(father,node_1,node_2);
if first == last
    return;
end
tr.tree = father;

% modify l_node
l_node = tr.l_node;
idx_f = (l_node==first);
idx_l = (l_node==last);
l_node(idx_f) = last;
l_node(idx_l) = first;
tmp = l_node(first);
l_node(first) = l_node(last);
l_node(last) = tmp;
tr.l_node = l_node;

% modify r_node
r_node = tr.r_node;
idx_f = (r_node==first);
idx_l = (r_node==last);
r_node(idx_f) = last;
r_node(idx_l) = first;
tmp = r_node(first);
r_node(first) = r_node(last);
r_node(last) = tmp;
tr.r_node = r_node;