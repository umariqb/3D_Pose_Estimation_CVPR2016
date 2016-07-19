function p_val = get(dg,p_name)

% GET get method
% ---------------------------------------
% property_value = get(dg, property_name)
% ---------------------------------------
% Description: gets field values.
% Input:       {dg} DIGRAPH instance(s).
%              {property_name} legal property.
% Output:      {property_value} value of {property_name}. If {dg} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {dg}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 12-Jan-2005

% first argument is assured to be the DIGRAPH. second argument is the
% property name
p_val = cell(size(dg));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% second argument is the property name
for ii = 1:numel(dg)
    switch str2keyword(p_name,3)
        case 'thd'
            p_val{ii} = dg(ii).thd;
        case 'gra'
            p_val{ii} = dg(ii).graph;
        otherwise
            p_val{ii} = get(dg(ii).graph,p_name);
    end
end

% if {dg} is a scalar, don't return cell
if numel(dg) == 1
    p_val = p_val{1};
end