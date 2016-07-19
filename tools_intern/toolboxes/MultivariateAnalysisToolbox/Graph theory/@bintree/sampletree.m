function [trr, list] = sampletree(tr,no_leaves)

% SAMPLETREE samples the tree such as to keep a smaller number of leaves.
% --------------------------------------
% [trr list] = sampletree(tr, no_leaves)
% --------------------------------------
% Description: samples the tree such as to keep a smaller number of leaves.
%              The algorithm picks the remaining leaves not in random, but
%              in a way that guarantees maximal dispersion.
% Input:       {tr} BINTREE instance.
%              {no_leaves} number of leaves in the sparse tree.
% Output:      {trr} new BINTREE.
%              {list} list of nodes that remain in the subree.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 15-Mar-2006

% parse input
error(chkvar(tr,{},'scalar',{'mfilename',inputname(1),1}));
error(chkvar(no_leaves,'integer',...
    {'scalar',{'eqgreater',2},{'eqlower',nonodes(tr)}},...
    {'mfilename',inputname(2),2}));

% initialize
pa = get(tr,'parents');
list = root(tr);
pa_list = 0;
potents = [tr.l_node(list) tr.r_node(list)];
nodes_left = 2*no_leaves - 2;

% progressively select nodes until the desired number of leaves is found
while length(potents) < 0.5*nodes_left
    % select potents
    list = [list potents];
    for ii = 1:length(potents)
        pa_list = [pa_list find(list==pa(potents(ii)))];
    end
    nodes_left = nodes_left - length(potents);
    % find the descendants of the current potents
    l_nodes = tr.l_node(potents);
    r_nodes = tr.r_node(potents);
    % remove those that are leaves
    idx = find(l_nodes == 0);
    l_nodes(idx) = [];
    r_nodes(idx) = [];
    % find the new potents
    potents = [l_nodes r_nodes];
end

% complete the selection of nodes - left descendants
for node = l_nodes
    idx = randorder(leavesunder(tr,node));
    list = [list idx(1)];
    pa_list = [pa_list find(list==pa(node))];
    nodes_left = nodes_left - 1;
end

% complete the selection of nodes - right descendants
if nodes_left > 0
    r_nodes = randorder(r_nodes);
    for ii = 1:nodes_left
        node = r_nodes(ii);
        idx = randorder(leavesunder(tr,node));
        list = [list idx(1)];
        pa_list = [pa_list find(list==pa(node))];
    end
end

% build new tree
trr = bintree('parents',pa_list);

% update node names and masses
node_name = get(tr,'node_name');
node_mass = get(tr,'node_mass');
trr = set(trr,'node_name',node_name(list),'node_mass',node_mass(list));

% modify customized fields
cnames = cfieldnames(tr);
for ii = 1:length(cnames)
    f_val = getcfield(tr,cnames{ii});
    trr = setcfield(trr,cnames{ii},f_val(list));
end