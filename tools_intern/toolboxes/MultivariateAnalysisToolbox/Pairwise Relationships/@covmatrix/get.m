function p_val = get(cvm,p_name)

% GET get method
% ---------------------------------------
% property_value = get(cvm, property_name)
% ---------------------------------------
% Description: gets field values.
% Input:       {cvm} COVMATRIX instance(s).
%              {property_name} legal property.
% Output:      {property_value} value of {property_name}. If {cvm} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {cvm}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 13-Jan-2005

% first argument is assured to be the COVMATRIX. second argument is the
% property name
p_val = cell(size(cvm));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {cvm}
for ii = 1:numel(cvm)
    switch str2keyword(p_name,4)
        case 'cov_'
            p_val{ii} = cvm(ii).cov_type;
        case 'no_s'
            p_val{ii} = cvm(ii).no_samples;
        case 'hypo'
            p_val{ii} = cvm(ii).hypothesis;
        case 'p_va'
            p_val{ii} = cvm(ii).p_value;
        case 'vvma'
            p_val{ii} = cvm(ii).vvmatrix;
        otherwise
            p_val{ii} = get(cvm(ii).vvmatrix,p_name);
    end
end

% if {cvm} is a scalar, don't return cell
if isscalar(cvm)
    p_val = p_val{1};
end