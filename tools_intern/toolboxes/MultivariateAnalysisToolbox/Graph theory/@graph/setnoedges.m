function gr = setnoedges(gr,no_edges)

% SETNOEDGES sets the number of edges in the graph.
% -----------------------------
% gr = setnoedges(gr, no_edges)
% -----------------------------
% Description: sets the number of edges in the graph.
% Input:       {gr} graph instance(s).
%              {no_edges} number of edges. If {gr} is not a scalar,
%                   {no_edges} should either match in dimensions, or be a
%                   common scalar to all instances.
% Output:      {gr} updated instance(s).
% Warning:     The field 'no_edges' is read-only and should not be changed
%              by the user. This function allows derived object to control
%              this field.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 07-Jan-2005

% compare dimensions of {gr} and {no_edges}
if isscalar(no_edges)
    no_edges = no_edges*ones(size(gr));
end
if any(size(no_edges) ~= size(gr))
    error('%s and %s should match in size',inputname(1),inputname(2));
end

% substitute no_edges
for ii = numel(gr)
    gr(ii).no_edges = no_edges(ii);
end