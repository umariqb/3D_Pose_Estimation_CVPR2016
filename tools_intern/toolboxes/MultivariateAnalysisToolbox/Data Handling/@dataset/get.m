function p_val = get(ds,p_name)

% GET get method
% ---------------------------------------
% property_value = get(ds, property_name)
% ---------------------------------------
% Description: gets field values.
% Input:       {ds} dataset instance(s).
%              {property_name} any field name.
% Output:      {property_value} value of {property_name}. If {ds} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {ds}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 06-Jan-2005

% first argument is assured to be the dataset. second argument is the
% property name
p_val = cell(size(ds));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {gr}
for ii = 1:numel(ds)
    switch str2keyword(p_name,4)
        case 'name'
            p_val{ii} = ds(ii).name;
        case 'desc'
            p_val{ii} = ds(ii).description;
        case 'sour'
            p_val{ii} = ds(ii).source;
        case 'vari'
            p_val{ii} = ds(ii).variables;
        case 'no_v'
            p_val{ii} = ds(ii).no_variables;
        case 'grou'
            p_val{ii} = ds(ii).groupings;
        case 'no_g'
            p_val{ii} = ds(ii).no_groupings;
        case 'samp'
            p_val{ii} = ds(ii).samplesets;
        case 'no_s'
            p_val{ii} = ds(ii).no_samplesets;
        case 'matr'
            p_val{ii} = ds(ii).matrix;
        case 'no_m'
            p_val{ii} = ds(ii).no_matrices;
        case 'var2'
            p_val{ii} = ds(ii).var2sampset;
        case 'grp2'
            p_val{ii} = ds(ii).grp2sampset;
        otherwise
            error('%s: not a field of DATASET',upper(p_name));
    end
end

% if {ds} is a scalar, don't return cell
if isscalar(ds)
    p_val = p_val{1};
end