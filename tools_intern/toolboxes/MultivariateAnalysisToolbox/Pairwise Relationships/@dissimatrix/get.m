function p_val = get(dsm,p_name)

% GET get method
% ----------------------------------------
% property_value = get(dsm, property_name)
% ----------------------------------------
% Description: gets field values.
% Input:       {dsm} DISSIMATRIX instance(s).
%              {property_name} legal property.
% Output:      {property_value} value of {property_name}. If {dsm} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {dsm}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 13-Jan-2005

% first argument is assured to be the DISSIMATRIX. second argument is the
% property name
p_val = cell(size(dsm));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {cvm}
for ii = 1:numel(dsm)
    switch str2keyword(p_name,4)
        case 'diss'
            p_val{ii} = dsm(ii).dissim_type;
        case 'no_v'
            p_val{ii} = dsm(ii).no_variables;
        case 'ssma'
            p_val{ii} = dsm(ii).ssmatrix;
        otherwise
            p_val{ii} = get(dsm(ii).ssmatrix,p_name);
    end
end