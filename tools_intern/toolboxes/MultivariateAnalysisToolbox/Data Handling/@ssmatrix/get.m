function p_val = get(ssm,p_name)

% GET get method
% ---------------------------------------
% property_value = get(ssm, property_name)
% ---------------------------------------
% Description: gets field values.
% Input:       {ssm} SSMATRIX instance(s).
%              {property_name} legal property.
% Output:      {property_value} value of {property_name}. If {ssm} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {ssm}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 12-Aug-2005

% first argument is assured to be the SSMATRIX. second argument is the
% property name
p_val = cell(size(ssm));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {vsm}
for ii = 1:numel(ssm)
    switch str2keyword(p_name,5)
        case 'row_s'
            if ssm(ii).isroweqcol
                p_val{ii} = ssm(ii).sampleset;
            else
                p_val{ii} = ssm(ii).row_sampleset;
            end
        case 'col_s'
            if ssm(ii).isroweqcol
                p_val{ii} = ssm(ii).sampleset;
            else
                p_val{ii} = ssm(ii).col_sampleset;
            end
        case 'sampl'
            error(['Field ''sampleset'' cannot be addressed directly. ' ...
                'Use ''row_sampleset'' or ''col_sampleset'' instead.']);
        case 'matri'
            p_val{ii} = ssm(ii).matrix;
        case 'row_g'
            if ssm(ii).isroweqcol
                p_val{ii} = ssm(ii).groupings;
            else
                p_val{ii} = ssm(ii).row_groupings;
            end
        case 'col_g'
            if ssm(ii).isroweqcol
                p_val{ii} = ssm(ii).groupings;
            else
                p_val{ii} = ssm(ii).col_groupings;
            end
        case 'group'
            error(['Field ''groupings'' cannot be addressed directly. ' ...
                'Use ''row_groupings'' or ''col_groupings'' instead.']);
        case 'isrow'
            p_val{ii} = ssm(ii).isroweqcol;
        case 'modif'
            p_val{ii} = ssm(ii).modifications;
        case 'datam'
            p_val{ii} = ssm(ii).datamatrix;
        otherwise
            p_val{ii} = get(ssm(ii).datamatrix,p_name);
    end
end

% if {ssm} is a scalar, don't return cell
if isscalar(ssm)
    p_val = p_val{1};
end