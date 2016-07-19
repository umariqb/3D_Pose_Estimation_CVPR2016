function p_val = get(ct,p_name)

% GET get method
% ---------------------------------------
% property_value = get(ct, property_name)
% ---------------------------------------
% Description: gets field values.
% Input:       {ct} CTABLE instance(s).
%              {property_name} legal property.
% Output:      {property_value} value of {property_name}. If {ct} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {ct}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 16-Feb-2005

% first argument is assured to be the CTABLE. second argument is the
% property name
p_val = cell(size(ct));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {ct}
for ii = 1:numel(ct)
    switch str2keyword(p_name,5)
        case 'indic'
            p_val{ii} = ct(ii).indices;
        case 'row_n'
            p_val{ii} = ct(ii).row_name;
        case 'col_n'
            p_val{ii} = ct(ii).col_name;
        otherwise
            p_val{ii} = get(ct(ii).vvmatrix,p_name);
    end
end

% if {ct} is a scalar, don't return cell
if isscalar(ct)
    p_val = p_val{1};
end