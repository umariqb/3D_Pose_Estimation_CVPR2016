function p_val = get(sim,p_name)

% GET get method
% ----------------------------------------
% property_value = get(sim, property_name)
% ----------------------------------------
% Description: gets field values.
% Input:       {sim} SIMATRIX instance(s).
%              {property_name} legal property.
% Output:      {property_value} value of {property_name}. If {sim} is not
%                   a scalar, {property_value} is a cell of the dimensions
%                   of {sim}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 13-Jan-2005

% first argument is assured to be the SIMATRIX. second argument is the
% property name
p_val = cell(size(sim));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {cvm}
for ii = 1:numel(sim)
    switch str2keyword(p_name,4)
        case 'sim_'
            p_val{ii} = sim(ii).sim_type;
        case 'no_v'
            p_val{ii} = sim(ii).no_variables;
        case 'ssma'
            p_val{ii} = sim(ii).ssmatrix;
        otherwise
            p_val{ii} = get(sim(ii).ssmatrix,p_name);
    end
end

% if {sim} is a scalar, don't return cell
if isscalar(sim)
    p_val = p_val{1};
end