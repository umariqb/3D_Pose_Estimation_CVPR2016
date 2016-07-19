function [binvar, where] = cfieldexist(gr,field_name)

% CFIELDEXIST finds whether a customized field exists in a graph.
% --------------------------------------------
% [binvar where] = cfieldexist(gr, field_name)
% --------------------------------------------
% Description: finds whether a customized field exists in a graph.
% Input:       {gr} graph instance(s).
%              {field_name} name of field.
% Output:      {binvar} a logical variable of the same size as {gr}. It is
%                   true if the field exist, and false otherwise.
%              {where} a integer of the same size as {gr}. It is the
%                   index of the cfield if it exists, and NaN otherwise.

% © Liran Carmel
% Classification: Customized fields manipulations
% Last revision date: 21-Dec-2004

% relatively low-level function, so no parsing is carried out

% initialize
binvar = true(size(gr));
where = nan(size(gr));

% loop on all instances
for ii = 1:numel(gr)
    wh = find(strcmp(get(gr(ii),'node_cfield_name'),field_name));
    if isempty(wh)
        binvar(ii) = false;
        where(ii) = NaN;
    else
        where(ii) = wh;
    end
end