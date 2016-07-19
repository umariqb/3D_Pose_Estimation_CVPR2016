function p_val = get(pt,p_name)

% GET get method
% ---------------------------------------
% property_value = get(pt, property_name)
% ---------------------------------------
% Description: gets field values.
% Input:       {pt} PCATRANS instance(s).
%              {property_name} legal property.
% Output:      {property_value} value of {property_name}. If {pt} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {pt}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 01-Feb-2005

% first argument is assured to be the PCATRANS. second argument is the
% property name
p_val = cell(size(pt));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {vsm}
for ii = 1:numel(pt)
    switch str2keyword(p_name,4)
        case 'algo'
            p_val{ii} = pt(ii).algorithm;
        case 'orth'
            p_val{ii} = pt(ii).ortho_constraints;
        case 'lint'
            p_val{ii} = pt(ii).lintrans;
        otherwise
            p_val{ii} = get(pt(ii).lintrans,p_name);
    end
end

% if {pt} is a scalar, don't return cell
if isscalar(pt)
    p_val = p_val{1};
end