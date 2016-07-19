function tr = prunesubtree(tr,node)

% PRUNESUBTREE prunes a subtree.
% ---------------------------
% tr = prunesubtree(tr, node)
% ---------------------------
% Description: prunes a subtree.
% Input:       {tr} TREE instance.
%              {node} the root of the subtree.
% Output:      {tr} new TREE.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 28-Feb-2007

% parse input - CHKVAR is done in DESCENDANTS
error(nargchk(2,2,nargin));

% find descendants of {node}, excluding {node} itself
nodes_to_remove = descendants(tr,node);
nodes_to_remove(1) = [];

% rename nodes
mapping = nan(1,nonodes(tr));
nodes_remain = allbut(nodes_to_remove,nonodes(tr));
no_nodes = length(nodes_remain);
mapping(nodes_remain) = 1:no_nodes;

% update description
desc = get(tr,'description');
if isempty(desc)
    desc = 'pruned';
elseif ~strcmp(desc,'pruned')
    desc = [desc '; pruned'];
end
% update node_name
node_name = get(tr,'node_name');
node_name = node_name(nodes_remain);
% update node_mass
node_mass = get(tr,'node_mass');
node_mass = node_mass(nodes_remain);
% update node_cfield
node_cfield = get(tr,'node_cfield');
for ii = 1:get(tr,'no_node_cfields')
    node_cfield{ii} = node_cfield{ii}(nodes_remain);
end
% update weights
W = get(tr,'weights');
W = W(nodes_remain,nodes_remain);
% update thd
D = get(tr,'thd');
D = D(nodes_remain,nodes_remain);
% update parent
pa = tr.parent;
pa = pa(nodes_remain);
idx = find(pa);
pa(idx) = mapping(pa(idx));
% update l_node & r_node
l_node = get(tr,'l_node');
l_node(node) = 0;
l_node = l_node(nodes_remain);
idx = find(l_node);
l_node(idx) = mapping(l_node(idx));
r_node = get(tr,'r_node');
r_node(node) = 0;
r_node = r_node(nodes_remain);
r_node(idx) = mapping(r_node(idx));

% set everything into the subtree
tr = set(tr,'description',desc,'node_name',node_name,...
    'node_mass',node_mass,'node_cfield',node_cfield,...
    'weights',W,'thd',D,'parent',pa,...
    'l_node',l_node,'r_node',r_node);