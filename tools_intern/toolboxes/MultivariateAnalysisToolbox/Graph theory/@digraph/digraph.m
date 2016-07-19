function dg = digraph(varargin)

% DIGRAPH constructor method
% ----------------------------------------------
% (1) dg = digraph()
% (2) dg = digraph(no_instances)
% (3) dg = digraph(dg0)
% (4) dg = digraph(field_name, field_value, ...)
% (5) dg = digraph('enum', no_nodes, node_names)
% ----------------------------------------------
% Description: constructs a DIGRAPH instance.
% Input:       (1) An empty default digraph is formed.
%              (2) {dg0} digraph instance. In this case {dg} would be an
%                  identical copy.
%              (3) {no_instances} integer. In this case {dg} would be an
%                  empty digraph vector of length {no_instances}.
%              (4) pairs of field names accompanied by their corresponding
%                  values. Supported fields are:
%                  'weights' - weight matrix. Can be in the form of a
%                       matrix, as an ssmatrix or as a vvmatrix.
%                  'thd' - target height differences matrix.
%                  'mass' - mass matrix, or masses vector.
%                  Notice that at least one of 'weights' and 'thd' should
%                  be present.
%              (5) enumerates all possible DAGs (including non-connected
%                  DAGs) connecting the nodes.
%                  {no_nodes} number of nodes.
%                  <{node_names}> a cell array with the node names.
% Output:      {dg} instance(s) of the DIGRAPH class.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 16-Jan-2008

% decide on which kind of constructor should be used
if nargin == 0      % case (1)
    gr = graph;         % GRAPH object
    gr = set(gr,'type','digraph');
    dg.thd = [];      % target height differences matrix
    dg = class(dg,'digraph',gr);
elseif isa(varargin{1},'digraph')  % case (2)
    error(nargchk(1,1,nargin));
    dg = varargin{1};
elseif isa(varargin{1},'double')    % case (3)
    error(nargchk(1,1,nargin));
    dg = [];
    for ii = 1:varargin{1}
        dg = [dg digraph];
        dg(ii) = set(dg(ii),'name',sprintf('Digraph #%d',ii));
    end
elseif strcmpi(varargin{1},'enum')  % case (5)
    % default node names
    no_nodes = varargin{2};
    if nargin < 3
        node_names = cell(1,no_nodes);
        for ii = 1:no_nodes
            node_names{ii} = sprintf('Node #%d',ii);
        end
    else
        node_names = varargin{3};
    end
    % enumeration algorithm (brute force)
    no_edges = 0.5*no_nodes*(no_nodes-1);
    edge_state = zero(1,no_edges);
    dg = digraph('thd',zeros(no_nodes));
    lst = 1;
    while 1
        
    end
else    % case (4)
    error(nargchk(2,Inf,nargin));
    error(chkvar(nargin,{},'even',{mfilename,'Number of arguments',0}));
    % initialize
    W = [];
    D = [];
    M = [];
    % loop on pairs
    for ii = 1:2:nargin
        switch str2keyword(varargin{ii},3)
            case 'wei'
                W = varargin{ii+1};
            case 'thd'
                D = varargin{ii+1};
            case 'mas'
                M = varargin{ii+1};
            otherwise
                error('%s: Unfamiliar property',upper(varargin{ii}));
        end
    end
    % generate graph instance
    if isempty(W)
        if ~isempty(D)
            W = thd2wgt(D);
        else
            error('Either weights or THDs should be supplied');
        end
    end
    if isempty(M)
        gr = graph(W);
    else
        gr = graph(W,M);
    end
    gr = set(gr,'type','digraph');
    % generate matrix of target height differences
    if isempty(D)
        dg.thd = wgt2thd(W);
    else
        error(chkvar(D,'numeric',...
            {'matrix',{'size',[get(gr,'no_nodes') get(gr,'no_nodes')]}},...
            {mfilename,'Target Height Differences',0}));
        dg.thd = sparse(D);
    end
    no_edges = computenoedges(W,D);
    gr = setnoedges(gr,no_edges);
    dg = class(dg,'digraph',gr);
end