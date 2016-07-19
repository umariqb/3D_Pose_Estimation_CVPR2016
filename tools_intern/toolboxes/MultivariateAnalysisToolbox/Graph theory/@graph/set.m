function gr = set(gr,varargin)

% SET set method
% -----------------------------------------------
% gr = set(gr, property_name, property_value,...)
% -----------------------------------------------
% Description: sets field values.
% Input:       {gr} graph instance.
%              {property_name},{property_value} legal pairs.
% Output:      {gr} updated graph instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 03-Dec-2004

% first argument is assured to be the graph. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(gr);
for ii = 1:2:length(varargin)
    error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii+1}));
    errmsg = {mfilename,'',ii+2};
    switch str2keyword(varargin{ii},12)
        case 'name        '     % field: name
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                % do not allow empty name
                if isempty(varargin{ii+1})
                    gr(jj).name = 'unnamed';
                else
                    gr(jj).name = varargin{ii+1};
                end
            end
        case 'description '     % field: description
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                gr(jj).description = varargin{ii+1};
            end
        case 'source      '     % field: source
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                gr(jj).source = varargin{ii+1};
            end
        case 'type        '     % field: type
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                gr(jj).type = varargin{ii+1};
            end
        case 'no_nodes    '     % field: no_nodes
            error('NO_NODES: field is read-only');
        case 'node_name   '
            error(chkvar(varargin{ii+1},'cell','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                gr(jj).node_name = varargin{ii+1};
            end
        case 'node_mass   '     % field: node_mass
            error(chkvar(varargin{ii+1},'numeric','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                gr(jj).node_mass = varargin{ii+1};
            end
        case 'node_cfield '     % field: node_cfield
            error(chkvar(varargin{ii+1},'cell','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                gr(jj).node_cfield = varargin{ii+1};
            end
        case 'node_cfield_'     % field: node_cfield_name
            error(chkvar(varargin{ii+1},'cell','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                gr(jj).node_cfield_name = varargin{ii+1};
                gr(jj).no_node_cfields = length(varargin{ii+1});
            end
        case 'no_node_cfie'     % field: no_node_cfields
            error('NO_NODE_CFIELDS: field is read-only');
        case 'weights     '     % field: weights
            error(chkvar(varargin{ii+1},'numeric',{'matrix','square'},errmsg));
            % loop on instances
            for jj = 1:no_instances
                gr(jj).weights = varargin{ii+1};
                gr(jj).no_nodes = size(varargin{ii+1},2);
                gr(jj).no_edges = computenoedges(varargin{ii+1});
            end
        case 'no_edges    '     % field: no_edges
            error('NO_EDGES: field is read-only');
        otherwise
            error('Property %s unsupported by SET',upper(varargin{ii}));
    end
end