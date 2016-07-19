function [tr, list] = subtree(tr,node)

% SUBTREE isolates the subtree branching from a certain node.
% -----------------------------
% [tr list] = subtree(tr, node)
% -----------------------------
% Description: isolates the subtree branching from a certain node.
% Input:       {tr} tree instance.
%              {node} the node to be the root of the new tree.
% Output:      {tr} new tree.
%              {list} list of nodes that remain in the subree.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 09-Aug-2005

% parse input - CHKVAR is done in DESCENDANTS
error(nargchk(2,2,nargin));

% find descendants of {node}
list = descendants(tr,node);

% return in a trivial case
if node == root(tr)
    return;
end

% update parent
pa = get(tr,'parent');
pa(node) = 0;
pa = pa(list);
for ii = 1:length(list)
    nd = list(ii);
    pa(pa==nd) = ii;
end
% update thd
D = get(tr,'thd');
D = D(list,list);
% update no_nodes
no_nodes = length(list);
% update node_name
node_name = get(tr,'node_name');
node_name = node_name(list);
% update node_mass
node_mass = get(tr,'node_mass');
node_mass = node_mass(list);
% update node_cfield
node_cfield = get(tr,'node_cfield');
for ii = 1:get(tr,'no_node_cfields')
    node_cfield{ii} = node_cfield{ii}(list);
end
% update weights
W = get(tr,'weights');
W = W(list,list);

% set everything into the subtree
tr = set(tr,'parent',pa,'thd',D,'node_name',node_name,...
    'node_mass',node_mass,'node_cfield',node_cfield,...
    'weights',W);