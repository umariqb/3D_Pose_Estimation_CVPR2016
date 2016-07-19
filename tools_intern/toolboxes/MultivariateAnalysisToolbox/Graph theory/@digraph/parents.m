function pa = parents(dg,nodes)

% PARENTS finds the parents of specific nodes.
% ----------------------
% pa = parents(dg,nodes)
% ----------------------
% Description: finds the parents of specific nodes.
% Input:       {dg} DIGRAPH instance.
%              {nodes} list of nodes, either as IDs or their names.
% Output:      {pa} cell array of IDs of parent nodes (a cell per each
%                   input node).

% © Liran Carmel
% Classification: Tree structure
% Last revision date: 17-Jan-2008

% list nodes by ID
if isa(nodes,'cell')
    nodes = name2idx(dg,nodes);
end

% initialize
pa = cell(size(nodes));
D = get(dg,'thd');

% loop on all nodes
for ii = 1:numel(nodes)
    node = nodes(ii);
    pa{ii} = find(D(node,:)<0);
end