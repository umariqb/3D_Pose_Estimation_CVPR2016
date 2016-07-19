function p_val = get(dm,p_name)

% GET get method
% ---------------------------------------
% property_value = get(dm, property_name)
% ---------------------------------------
% Description: gets field values.
% Input:       {dm} datamatrix instance(s).
%              {property_name} legal property.
% Output:      {property_value} value of {property_name}. If {dm} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {dm}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 10-Jan-2005

% first argument is assured to be the datamatrix. second argument is the
% property name
p_val = cell(size(dm));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {dm}
for ii = 1:numel(dm)
    switch str2keyword(p_name,4)
        case 'name'
            p_val{ii} = dm(ii).name;
        case 'desc'
            p_val{ii} = dm(ii).description;
        case 'sour'
            p_val{ii} = dm(ii).source;
        case 'type'
            p_val{ii} = dm(ii).type;
        case 'row_'
            p_val{ii} = dm(ii).row_type;
        case 'no_r'
            p_val{ii} = dm(ii).no_rows;
        case 'col_'
            p_val{ii} = dm(ii).col_type;
        case 'no_c'
            p_val{ii} = dm(ii).no_cols;
        otherwise
            error('%s: not a field of DATAMATRIX',upper(p_name));
    end
end

% if {dm} is a scalar, don't return cell
if isscalar(dm)
    p_val = p_val{1};
end