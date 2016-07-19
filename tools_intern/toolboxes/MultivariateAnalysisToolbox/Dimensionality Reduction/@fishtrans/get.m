function p_val = get(ft,p_name)

% GET get method
% ---------------------------------------
% property_value = get(ft, property_name)
% ---------------------------------------
% Description: gets field values.
% Input:       {ft} FISHTRANS instance(s).
%              {property_name} legal property.
% Output:      {property_value} value of {property_name}. If {ft} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {ft}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 01-Feb-2005

% first argument is assured to be the FISHTRANS. second argument is the
% property name
p_val = cell(size(ft));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {vsm}
for ii = 1:numel(ft)
    switch str2keyword(p_name,4)
        case 'rati'
            p_val{ii} = ft(ii).ratio;
        case 'orth'
            p_val{ii} = ft(ii).ortho_constraints;
        case 'lint'
            p_val{ii} = ft(ii).lintrans;
        otherwise
            p_val{ii} = get(ft(ii).lintrans,p_name);
    end
end

% if {ft} is a scalar, don't return cell
if isscalar(ft)
    p_val = p_val{1};
end