function no_edges = noedges(gr)

% NOEDGES retrieves the number of edges in graph objects.
% ----------------------
% no_edges = noedges(gr)
% ----------------------
% Description: retrieves the number of edges in graph objects.
% Input:       {gr} a group instance.
% Output:      {no_edges} number of edges.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 03-Dec-2004

% initialize
no_edges = zeros(size(gr));

% compute
for ii = 1:numel(gr)
    no_edges(ii) = gr(ii).no_edges;
end