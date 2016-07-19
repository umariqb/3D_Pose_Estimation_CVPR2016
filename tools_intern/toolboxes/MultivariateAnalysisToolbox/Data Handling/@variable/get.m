function p_val = get(vr,p_name)

% GET get method
% ---------------------------------------
% property_value = get(vr, property_name)
% ---------------------------------------
% Description: gets field values.
% Input:       {vr} variable instance(s).
%              {property_name} any field name.
% Output:      {property_value} value of {property_name}. If {vr} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {vr}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 07-Mar-2006

% first argument is assured to be the variable. second argument is the
% property name
p_val = cell(size(vr));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {vr}
for ii = 1:numel(vr)
    switch str2keyword(p_name,4)
        case 'name'
            p_val{ii} = vr(ii).name;
        case 'desc'
            p_val{ii} = vr(ii).description;
        case 'sour'
            p_val{ii} = vr(ii).source;
        case 'data'
            p_val{ii} = vr(ii).data;
        case 'unit'
            p_val{ii} = vr(ii).units;
        case 'no_s'
            p_val{ii} = vr(ii).no_samples;
        case 'no_m'
            p_val{ii} = vr(ii).no_missing;
        case 'leve'
            p_val{ii} = vr(ii).level;
        case 'lut '
            p_val{ii} = vr(ii).lut;
        case 'tran'
            p_val{ii} = vr(ii).transformations;
        case 'minm'
            p_val{ii} = vr(ii).minmax;
        case 'mean'
            p_val{ii} = vr(ii).mean;
        case 'vari'
            p_val{ii} = vr(ii).variance;
        case 'dist'
            p_val{ii} = vr(ii).distribution;
        otherwise
            error('%s: not a field of VARIABLE',upper(p_name));
    end
end

% if {vr} is a scalar, don't return cell
if isscalar(vr)
    p_val = p_val{1};
end