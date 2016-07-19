function p_val = get(tr,p_name)

% GET get method
% ---------------------------------------
% property_value = get(tr, property_name)
% ---------------------------------------
% Description: gets field values.
% Input:       {tr} BINTREE instance(s).
%              {property_name} legal property.
% Output:      {property_value} value of {property_name}. If {tr} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {tr}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 12-Jan-2005

% first argument is assured to be the BINTREE. second argument is the
% property name
p_val = cell(size(tr));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% second argument is the property name
for ii = 1:length(tr)
    switch str2keyword(p_name,3)
        case 'l_n'
            p_val{ii} = tr(ii).l_node;
        case 'r_n'
            p_val{ii} = tr(ii).r_node;
        case 'tre'
            p_val{ii} = tr(ii).tree;
        otherwise
            p_val{ii} = get(tr(ii).tree,p_name);
    end
end

% if {tr} is a scalar, don't return cell
if numel(tr) == 1
    p_val = p_val{1};
end