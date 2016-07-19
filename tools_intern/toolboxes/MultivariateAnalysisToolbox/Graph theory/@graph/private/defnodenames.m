function node_name = defnodenames(no_nodes)

% DEFNODENAMES assigns default names to nodes.
% ----------------------------------
% node_name = defnodenames(no_nodes)
% ----------------------------------
% Description: assigns default names to nodes.
% Input:       {no_nodes} number of nodes in the graph.
% Output:      {node_name} cell array of names.

% © Liran Carmel
% Classification: Housekeeping functions
% Last revision date: 30-Nov-2006

% initialize
node_name = cell(1,no_nodes);

% loop
for ii = 1:no_nodes
    node_name{ii} = sprintf('Node #%d',ii);
end