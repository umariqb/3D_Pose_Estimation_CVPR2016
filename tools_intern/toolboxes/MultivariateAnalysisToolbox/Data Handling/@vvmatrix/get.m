function p_val = get(vvm,p_name)

% GET get method
% ---------------------------------------
% property_value = get(vvm, property_name)
% ---------------------------------------
% Description: gets field values.
% Input:       {vvm} VVMATRIX instance(s).
%              {property_name} legal property.
% Output:      {property_value} value of {property_name}. If {vvm} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {vvm}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 12-Jan-2005

% first argument is assured to be the VVMATRIX. second argument is the
% property name
p_val = cell(size(vvm));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {vvm}
for ii = 1:numel(vvm)
    switch str2keyword(p_name,5)
        case 'row_s'
            if vvm(ii).isroweqcol
                p_val{ii} = vvm(ii).sampleset;
            else
                p_val{ii} = vvm(ii).row_sampleset;
            end
        case 'col_s'
            if vvm(ii).isroweqcol
                p_val{ii} = vvm(ii).sampleset;
            else
                p_val{ii} = vvm(ii).col_sampleset;
            end
        case 'sampl'
            p_val{ii} = vvm(ii).sampleset;
        case 'matri'
            p_val{ii} = vvm(ii).matrix;
        case 'isrow'
            p_val{ii} = vvm(ii).isroweqcol;
        case 'datam'
            p_val{ii} = vvm(ii).datamatrix;
        otherwise
            p_val{ii} = get(vvm(ii).datamatrix,p_name);
    end
end

% if {vvm} is a scalar, don't return cell
if isscalar(vvm)
    p_val = p_val{1};
end