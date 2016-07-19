function no_nodes = nonodes(gr)

% NONODES retrieves the number of nodes in graph objects.
% ----------------------
% no_nodes = nonodes(gr)
% ----------------------
% Description: retrieves the number of nodes in graph objects.
% Input:       {gr} a group instance.
% Output:      {no_nodes} number of nodes.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 03-Dec-2004

% initialize
no_nodes = zeros(size(gr));

% compute
for ii = 1:numel(gr)
    no_nodes(ii) = gr(ii).no_nodes;
end