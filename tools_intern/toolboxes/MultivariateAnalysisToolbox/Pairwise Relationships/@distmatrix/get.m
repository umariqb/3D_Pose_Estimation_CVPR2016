function p_val = get(dstm,p_name)

% GET get method
% -----------------------------------------
% property_value = get(dstm, property_name)
% -----------------------------------------
% Description: gets field values.
% Input:       {dstm} DISTMATRIX instance(s).
%              {property_name} legal property.
% Output:      {property_value} value of {property_name}. If {dstm} is not
%                   a scalar, {property_value} is a cell of the dimensions
%                   of {dstm}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 13-Jan-2005

% first argument is assured to be the DISTMATRIX. second argument is the
% property name
p_val = cell(size(dstm));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {cvm}
for ii = 1:numel(dstm)
    switch str2keyword(p_name,4)
        case 'dist'
            p_val{ii} = dstm(ii).dist_type;
        case 'no_v'
            p_val{ii} = dstm(ii).no_variables;
        case 'ssma'
            p_val{ii} = dstm(ii).ssmatrix;
        otherwise
            p_val{ii} = get(dstm(ii).ssmatrix,p_name);
    end
end

% if {dstm} is a scalar, don't return cell
if isscalar(dstm)
    p_val = p_val{1};
end