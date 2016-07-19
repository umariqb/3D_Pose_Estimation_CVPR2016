function [dg, first, last] = swap(dg,node_1,node_2)

% SWAP replaces the indices of two nodes.
% ------------------------------------------
% [dg first last] = swap(dg, node_1, node_2)
% ------------------------------------------
% Description: replaces the indices of two nodes.
% Input:       {dg} digraph instance.
%              {node_1} first node.
%              {node_2} second node.
% Output:      {dg} the digraph with the two nodes replaced.
%              {first} the smallest of {node_1} and {node_2}.
%              {last} the highest of {node_1} and {node_2}.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 03-Sep-2004

% modify graph
gr = dg.graph;
[gr first last] = swap(gr,node_1,node_2);
if first == last
    return;
end
dg.graph = gr;

% modify thd
D = dg.thd;
tmp = D(first,:);
D(first,:) = D(last,:);
D(last,:) = tmp;
tmp = D(:,first);
D(:,first) = D(:,last);
D(:,last) = tmp;
dg.thd = D;