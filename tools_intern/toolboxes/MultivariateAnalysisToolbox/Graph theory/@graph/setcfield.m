function gr = setcfield(gr,field_name,field_value)

% SETCFIELD sets values for a customized field of a graph.
% -------------------------------------------
% gr = setcfield(gr, field_name, field_value)
% -------------------------------------------
% Description: sets values for a customized field of a graph. If this
%              field doesn't exists, error message is returned.
% Input:       {gr} graph instance(s).
%              {field_name} name of a field.
%              {field_value} either a cell array of length {no_nodes}, or a
%                   numerical matrix of size {anything}-by-{no_nodes} that
%                   is converted to a cell array.
% Output:      {gr} updated graph(s).

% © Liran Carmel
% Classification: Customized fields manipulations
% Last revision date: 30-Nov-2006

% relatively low-level function, so no parsing is carried out

% loop on all instances
for ii = 1:numel(gr)
    % error if the field doesn't exist
    [is_exist where] = cfieldexist(gr(ii),field_name);
    if ~is_exist
        if numel(gr) > 1
            error('%s: field does not exist in {%s}(%d)',...
                upper(field_name),inputname(1),ii);
        else
            error('%s: field does not exist in {%s}',...
                upper(field_name),inputname(1));
        end
    end
    % set value
    if iscell(field_value)  % cell
        gr(ii).node_cfield{where} = field_value;
    elseif ~isempty(field_value) % nonempty numerical
        gr(ii).node_cfield{where} = num2cell(field_value,1);
    else    % empty numerical
        gr(ii).node_cfield{where} = {[]};
    end
end