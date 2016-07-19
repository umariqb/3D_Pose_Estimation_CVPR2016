function field = getcfield(gr,field_name)

% GETCFIELD retrieves a customized field from a graph.
% ---------------------------------
% field = getcfield(gr, field_name)
% ---------------------------------
% Description: retrieves a customized field from a graph. If this
%              field doesn't exists, error message is returned.
% Input:       {gr} graph instance.
%              {field_name} name of a field.
% Output:      {field} field values, always a cell array of length
%                   {no_nodes}.

% © Liran Carmel
% Classification: Customized fields manipulations
% Last revision date: 22-Dec-2004

% relatively low-level function, so no parsing is carried out

% find whether this cfield exists
[is_exist where] = cfieldexist(gr,field_name);

% error if field doesn't exist
if ~is_exist
    error('%s: field does not exist in %s',upper(field_name),inputname(1));
end

% get values of the field
cfield = get(gr,'node_cfield');
field = cfield{where};