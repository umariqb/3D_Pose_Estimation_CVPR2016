function tr = tree(varargin)

% TREE constructor method
% -------------------------------------------
% (1) tr = tree()
% (2) tr = tree(no_instances)
% (3) tr = tree(tr0)
% (4) tr = tree(field_name, field_value, ...)
% -------------------------------------------
% Description: constructs a TREE instance.
% Input:       (1) An empty default tree is formed.
%              (2) {no_instances} integer. In this case {tr} would be an
%                  empty tree vector of length {no_instances}.
%              (3) {tr0} tree instance. In this case {tr} would be an
%                  identical copy.
%              (4) pairs of field names accompanied by their corresponding
%                  values. Supported fields are:
%                  'weights' - weight matrix. Can be in the form of a
%                       matrix, as an ssmatrix or as a vvmatrix.
%                  'thd' - target height differences matrix.
%                  'mass' - mass matrix, or masses vector.
%                  'parents' - parents vector.
% Output:      {tr} an instance of the TREE class.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 03-Sep-2004

% decide on which kind of constructor should be used
if nargin == 0      % case (1)
    dg = digraph;           % DIGRAPH object
    dg = set(dg,'type','tree');
    tr.parent = [];      % parents vector
    tr = class(tr,'tree',dg);
elseif isa(varargin{1},'tree')  % case (2)
    error(nargchk(1,1,nargin));
    tr = varargin{1};
elseif isa(varargin{1},'double')    % case (3)
    error(nargchk(1,1,nargin));
    tr = [];
    for ii = 1:varargin{1}
        tr = [tr tree];
        tr(ii).name = sprintf('Tree #%d',ii);
    end
else    % case (4)
    error(nargchk(2,Inf,nargin));
    error(chkvar(nargin,{},'even',{mfilename,'Number of arguments',0}));
    % initialize
    W = [];
    D = [];
    M = [];
    p = [];
    % loop on pairs
    for ii = 1:2:nargin
        switch str2keyword(varargin{ii},3)
            case 'wei'
                W = varargin{ii+1};
            case 'thd'
                D = varargin{ii+1};
            case 'mas'
                M = varargin{ii+1};
            case 'par'
                p = varargin{ii+1};
            otherwise
                error('%s: Unfamiliar property',upper(varargin{ii}));
        end
    end
    % generate digraph instance
    if isempty(W) && isempty(D)
        if isempty(p)
            error('Either of weights, THDs and parent should be nonempty');
        end
        D = par2thd(p);
    end
    dg = digraph('weigths',W,'thd',D,'masses',M);
    dg = set(dg,'type','tree');
    % compute parent vector (if necessary)
    if isempty(p)
        p = thd2par(get(dg,'thd'));
    end
    tr.parent = p;
    tr = class(tr,'tree',dg);
end