function p_val = get(gr,p_name)

% GET get method
% ---------------------------------------
% property_value = get(gr, property_name)
% ---------------------------------------
% Description: gets field values.
% Input:       {gr} grouping instance(s).
%              {property_name} any field name.
% Output:      {property_value} value of {property_name}. If {gr} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {gr}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 12-Jan-2005

% first argument is assured to be the grouping. second argument is the
% property name
p_val = cell(size(gr));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {gr}
for ii = 1:numel(gr)
    switch str2keyword(p_name,4)
        case 'name'
            p_val{ii} = gr(ii).name;
        case 'desc'
            p_val{ii} = gr(ii).description;
        case 'sour'
            p_val{ii} = gr(ii).source;
        case 'no_s'
            p_val{ii} = gr(ii).no_samples;
        case 'no_h'
            p_val{ii} = gr(ii).no_hierarchies;
        case 'no_g'
            p_val{ii} = gr(ii).no_groups;
        case 'assi'
            p_val{ii} = gr(ii).assignment;
        case 'nami'
            p_val{ii} = gr(ii).naming;
        case 'is_c'
            p_val{ii} = gr(ii).is_consistent;
        case 'gid2'
            p_val{ii} = gr(ii).gid2gcn;
        case 'gcn2'
            p_val{ii} = gr(ii).gcn2gid;
        otherwise
            error('%s: not a field of GROUPING',upper(p_name));
    end
end

% if {gr} is a scalar, don't return cell
if isscalar(gr)
    p_val = p_val{1};
end