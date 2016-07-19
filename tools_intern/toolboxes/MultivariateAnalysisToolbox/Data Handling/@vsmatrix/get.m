function p_val = get(vsm,p_name)

% GET get method
% ---------------------------------------
% property_value = get(vsm, property_name)
% ---------------------------------------
% Description: gets field values.
% Input:       {vsm} VSMATRIX instance(s).
%              {property_name} legal property.
% Output:      {property_value} value of {property_name}. If {vsm} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {vsm}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 12-Jan-2005

% first argument is assured to be the VSMATRIX. second argument is the
% property name
p_val = cell(size(vsm));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {vsm}
for ii = 1:numel(vsm)
    switch str2keyword(p_name,4)
        case 'samp'
            p_val{ii} = vsm(ii).sampleset;
        case 'vari'
            p_val{ii} = vsm(ii).variables;
        case 'grou'
            p_val{ii} = vsm(ii).groupings;
        case 'data'
            p_val{ii} = vsm(ii).datamatrix;
        otherwise
            p_val{ii} = get(vsm(ii).datamatrix,p_name);
    end
end

% if {vsm} is a scalar, don't return cell
if isscalar(vsm)
    p_val = p_val{1};
end