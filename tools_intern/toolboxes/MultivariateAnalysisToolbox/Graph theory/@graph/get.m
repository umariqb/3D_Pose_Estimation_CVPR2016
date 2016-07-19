function p_val = get(gr,p_name)

% GET get method
% ---------------------------------------
% property_value = get(gr, property_name)
% ---------------------------------------
% Description: gets field values.
% Input:       {gr} graph instance(s).
%              {property_name} legal property.
% Output:      {property_value} value of {property_name}. If {gr} is not a
%                   scalar, {property_value} is a cell of the dimensions of
%                   {gr}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 25-Oct-2004

% first argument is assured to be the graph. second argument is the
% property name
p_val = cell(size(gr));
error(chkvar(p_name,'char','vector',{mfilename,inputname(2),2}));

% substitute field value for each element in {gr}
for ii = 1:numel(gr)
    switch str2keyword(p_name,13)
        case 'name         '
            p_val{ii} = gr(ii).name;
        case 'description  '
            p_val{ii} = gr(ii).description;
        case 'source       '
            p_val{ii} = gr(ii).source;
        case 'type         '
            p_val{ii} = gr(ii).type;
        case 'no_nodes     '
            p_val{ii} = gr(ii).no_nodes;
        case 'node_name    '
            p_val{ii} = gr(ii).node_name;
        case 'node_mass    '
            p_val{ii} = gr(ii).node_mass;
        case 'node_cfield  '
            p_val{ii} = gr(ii).node_cfield;
        case 'node_cfield_n'
            p_val{ii} = gr(ii).node_cfield_name;
        case 'no_node_cfiel'
            p_val{ii} = gr(ii).no_node_cfields;
        case 'weights      '
            p_val{ii} = gr(ii).weights;
        case 'no_edges     '
            p_val{ii} = gr(ii).no_edges;
        otherwise
            error('%s: not a field of GRAPH',upper(p_name));
    end
end

% if {gr} is a scalar, don't return cell
if numel(gr) == 1
    p_val = p_val{1};
end