function p_val = get(lt,p_name)

% GET get method
% ---------------------------------------
% property_value = get(lt, property_name)
% ---------------------------------------
% Description: gets field values.
% Input:       {lt} lintrans instance(s).
%              {property_name} legal property.
% Output:      {property_value} value of {property_name}. If {lt} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {lt}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 01-Feb-2005

% first argument is assured to be the lintrans. second argument is the
% property name
p_val = cell(size(lt));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {dm}
for ii = 1:numel(lt)
    switch str2keyword(p_name,4)
        case 'type'
            p_val{ii} = lt(ii).type;
        case 'u   '
            p_val{ii} = lt(ii).U;
        case 'eigv'
            p_val{ii} = lt(ii).eigvals;
        case 'f_ei'
            p_val{ii} = lt(ii).f_eigvals;
        case 'fact'
            p_val{ii} = lt(ii).factorset;
        case 'no_f'
            p_val{ii} = lt(ii).no_factors;
        case 'vari'
            p_val{ii} = lt(ii).variableset;
        case 'no_v'
            p_val{ii} = lt(ii).no_variables;
        case 'no_s'
            p_val{ii} = lt(ii).no_samples;
        case 'prep'
            p_val{ii} = lt(ii).preprocess;
        case 'orig'
            p_val{ii} = lt(ii).orig_vars;
        case 'scor'
            p_val{ii} = lt(ii).scores;
        otherwise
            error('%s: not a field of LINTRANS',upper(p_name));
    end
end

% if {lt} is a scalar, don't return cell
if isscalar(lt)
    p_val = p_val{1};
end