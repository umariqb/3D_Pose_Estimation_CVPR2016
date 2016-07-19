function [tr, first, last] = swap(tr,node_1,node_2)

% SWAP replaces the indices of two nodes.
% ------------------------------------------
% [tr first last] = swap(tr, node_1, node_2)
% ------------------------------------------
% Description: replaces the indices of two nodes.
% Input:       {tr} tree instance.
%              {node_1} first node.
%              {node_2} second node.
% Output:      {tr} the tree with the two nodes replaced.
%              {first} the smallest of {node_1} and {node_2}.
%              {last} the highest of {node_1} and {node_2}.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 03-Sep-2004

% modify digraph
dg = tr.digraph;
[dg first last] = swap(dg,node_1,node_2);
if first == last
    return;
end
tr.digraph = dg;

% modify parent vector
pa = tr.parent;
idx_f = find(pa==first);
idx_l = find(pa==last);
pa(idx_f) = last;
pa(idx_l) = first;
tmp = pa(first);
pa(first) = pa(last);
pa(last) = tmp;
tr.parent = pa;