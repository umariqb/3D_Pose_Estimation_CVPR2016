function gr = graph(varargin)

% GRAPH constructor method
% ----------------------------
% (1) gr = graph()
% (2) gr = graph(no_instances)
% (3) gr = graph(gr0)
% (4) gr = graph(W,M)
% (5) gr = graph(filename)
% ----------------------------
% Description: constructs a GRAPH instance.
% Input:       (1) An empty default graph is formed.
%              (2) {gr0} graph instance. In this case {gr} would be an
%                  identical copy.
%              (3) {no_instances} integer. In this case {gr} would be an
%                  empty graph vector of length {no_instances}.
%              (4) {W} weight matrix. Can be in the form of a matrix, as an
%                       ssmatrix or as a vvmatrix.
%                  <{M}> - node masses. Either a vector of a matrix.
%              (5) {filename} from which to read the graph.
% Output:      {gr} an instance of the GRAPH class.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 02-Sep-2004

% decide on which kind of constructor should be used
error(nargchk(0,2,nargin));
switch nargin
    case 0  % case (1)
        gr.name = 'unnamed';        % name of graph
        gr.description = '';        % description of graph
        gr.source = '';             % source of graph
        gr.type = 'general graph';  % type of graph
        gr.no_nodes = 0;            % total number of nodes in the graph {n}
        gr.node_name = {};          % name of nodes
        gr.node_mass = [];          % mass of nodes
        gr.node_cfield = {};        % applcation-specific node customized fields
        gr.node_cfield_name = {};   % names of node customized fields
        gr.no_node_cfields = 0;     % number of node customized fields
        gr.weights = [];            % symmetric sparse weights matrix
        gr.no_edges = 0;            % total number of edges in the graph
        gr = class(gr,'graph');
    case 1
        if isa(varargin{1},'graph')  % case (3)
            gr = varargin{1};
        elseif isa(varargin{1},'char')    % case (5)
            [pathstr fn ext] = fileparts(varargin{1});  %#ok
            switch str2keyword(ext,3)
                case 'mtx'
                    gr.name = fn;
                    gr.source = 'MatrixMarket';
                    [gr.weights gr.no_nodes no_cols gr.no_edges rep field symm] = ...
                        mmread(varargin{1});    %#ok
                    if strcmp(symm,'symmetric')
                        gr.no_edges = gr.no_edges / 2;
                    end
                    gr.node_mass = ones(1,gr.no_nodes);
                otherwise
                    error('%s: Unfamiliar graph format',ext);
            end
        else
            [msg1 is_int] = chkvar(varargin{1},'integer','scalar',...
                {mfilename,'',1});
            if is_int   % case (2)
                gr = [];
                for ii = 1:varargin{1}
                    gr = [gr graph];
                    gr(ii).name = sprintf('Graph #%d',ii);
                end
            else    % case (4) with {M} omitted
                [msg2 is_numat] = chkvar(varargin{1},{'numeric','logical'},...
                    {'matrix','square'},{mfilename,'',1});
                if is_numat     % {W} is numerical
                    W = varargin{1};
                else
                    [msg3 is_prmat] = chkvar(varargin{1},...
                        {'ssmatrix','vvmatrix'},'scalar',{mfilename,'',1});
                    if is_prmat     % {W} is ssmatrix or vvmatrix
                        W = get(varargin{1},'matrix');
                    else
                        error('%s\n%s\n%s',msg1,msg2,msg3);
                    end
                end
                gr = graph;
                gr.weights = sparse(W);
                gr.no_nodes = size(W,1);
                no_self_edges = length(find(diag(W)));
                gr.no_edges = 0.5*length(find(W)) - 0.5*no_self_edges;
                gr.node_mass = ones(1,gr.no_nodes);
                gr.node_name = defnodenames(gr.no_nodes);
            end
        end
    case 2      % case (4)
        % get {W}
        [msg1 is_numat] = chkvar(varargin{1},'numeric',...
            {'matrix','square'},{mfilename,'',1});
        if is_numat     % {W} is numerical
            W = varargin{1};
        else
            [msg2 is_prmat] = chkvar(varargin{1},{'ssmatrix','vvmatrix'},...
                'scalar',{mfilename,'',1});
            if is_prmat     % {W} is ssmatrix or vvmatrix
                W = get(varargin{1},'matrix');
            else
                error('%s\n%s',msg1,msg2);
            end
            gr.weights = sparse(W);
            gr.no_nodes = size(W,1);
            gr.no_edges = computenoedges(W);
            gr.node_name = defnodenames(gr.no_nodes);
        end
        % get {M}
        [msg1 is_vec] = chkvar(varargin{2},'numerical',...
            {'vector',{'length',size(W,1)}},{mfilename,'',2});
        if is_vec
            gr.node_mass = varargin{2};
        else
            [msg2 is_mat] = chkvar(varargin{2},'numerical',...
                {'matrix',{'size',size(W)}},{mfilename,'',2});
            if is_mat
                gr.node_mass = diag(varargin{2});
            else
                error('%s\n%s',msg1,msg2);
            end
        end
end