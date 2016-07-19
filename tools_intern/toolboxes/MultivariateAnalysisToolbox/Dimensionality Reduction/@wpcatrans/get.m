function p_val = get(wpt,p_name)

% GET get method
% ----------------------------------------
% property_value = get(wpt, property_name)
% ----------------------------------------
% Description: gets field values.
% Input:       {wpt} WPCATRANS instance(s).
%              {property_name} legal property.
% Output:      {property_value} value of {property_name}. If {wpt} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {wpt}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 01-Feb-2005

% first argument is assured to be the WPCATRANS. second argument is the
% property name
p_val = cell(size(wpt));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {vsm}
for ii = 1:numel(wpt)
    switch str2keyword(p_name,4)
        case 'orth'
            p_val{ii} = wpt(ii).ortho_constraints;
        case 'lint'
            p_val{ii} = wpt(ii).lintrans;
        otherwise
            p_val{ii} = get(wpt(ii).lintrans,p_name);
    end
end

% if {wpt} is a scalar, don't return cell
if isscalar(wpt)
    p_val = p_val{1};
end