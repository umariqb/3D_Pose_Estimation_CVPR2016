function p_val = get(ss,p_name)

% GET get method
% ---------------------------------------
% property_value = get(ss, property_name)
% ---------------------------------------
% Description: gets field values.
% Input:       {ss} sampleset instance(s).
%              {property_name} any field name.
% Output:      {property_value} value of {property_name}. If {ss} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {ss}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 06-Jan-2005

% first argument is assured to be the ssouping. second argument is the
% property name
p_val = cell(size(ss));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {ss}
for ii = 1:numel(ss)
    switch str2keyword(p_name,4)
        case 'name'
            p_val{ii} = ss(ii).name;
        case 'desc'
            p_val{ii} = ss(ii).description;
        case 'sour'
            p_val{ii} = ss(ii).source;
        case 'samp'
            p_val{ii} = ss(ii).sample_names;
        case 'no_s'
            p_val{ii} = ss(ii).no_samples;
        otherwise
            error('%s: not a field of SAMPLESET',upper(p_name));
    end
end

% if {ss} is a scalar, don't return cell
if isscalar(ss)
    p_val = p_val{1};
end