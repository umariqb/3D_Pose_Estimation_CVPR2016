function [gr where] = alloccfield(gr,field_name)

% ALLOCCFIELD allocates a new customized field to a graph.
% --------------------------------
% gr = alloccfield(gr, field_name)
% --------------------------------
% Description: allocates a new customized field to a graph. If this field
%              already exists, no allocation is carried out, and the
%              original graph is returned.
% Input:       {gr} graph instance(s).
%              {field_name} name of a field.
% Output:      {gr} graph(s) with the new allocated cfield.
%              {where} a integer of the same size as {gr}. It is the
%                   index of the cfield.

% © Liran Carmel
% Classification: Customized fields manipulations
% Last revision date: 21-Dec-2004

% relatively low-level function, so no parsing is carried out

% find whether this cfield already exists
[is_exist where] = cfieldexist(gr,field_name);

% allocate whenever not already allocated
for ii = find(~is_exist)
    % retrieve cfields information
    cfield_name = get(gr(ii),'node_cfield_name');
    cfield = get(gr(ii),'node_cfield');
    % allocate
    cfield_name = [cfield_name {field_name}];
    where(ii) = length(cfield_name);
    cfield = [cfield {cell(1,get(gr(ii),'no_nodes'))}];
    % set into the phyltree
    gr(ii) = set(gr(ii),'node_cfield_name',cfield_name,...
        'node_cfield',cfield);
end