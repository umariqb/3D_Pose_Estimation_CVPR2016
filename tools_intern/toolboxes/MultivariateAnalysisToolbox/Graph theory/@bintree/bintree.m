function tr = bintree(varargin)

% BINTREE constructor method
% ----------------------------------------------
% (1) tr = bintree()
% (2) tr = bintree(no_instances)
% (3) tr = bintree(tr0)
% (4) tr = bintree(field_name, field_value, ...)
% ----------------------------------------------
% Description: constructs a BINTREE instance.
% Input:       (1) An empty default bintree is formed.
%              (2) {no_instances} integer. In this case {tr} would be an
%                  empty bintree vector of length {no_instances}.
%              (3) {tr0} bintree instance. In this case {tr} would be an
%                  identical copy.
%              (4) pairs of field names accompanied by their corresponding
%                  values. Supported fields are:
%                  'weights' - weight matrix. Can be in the form of a
%                       matrix, as an ssmatrix or as a vvmatrix.
%                  'thd' - target height differences matrix.
%                  'mass' - mass matrix, or masses vector.
%                  'parents' - parents vector.
% Output:      {tr} an instance of the BINTREE class.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 06-Oct-2004

% decide on which kind of constructor should be used
if nargin == 0      % case (1)
    father = tree;          % TREE object
    father = set(father,'type','binary tree');
    tr.l_node = [];      % left_nodes
    tr.r_node = [];      % right_nodes
    tr = class(tr,'bintree',father);
elseif isa(varargin{1},'bintree')  % case (2)
    error(nargchk(1,1,nargin));
    tr = varargin{1};
elseif isa(varargin{1},'double')    % case (3)
    error(nargchk(1,1,nargin));
    tr = [];
    for ii = 1:varargin{1}
        tr = [tr bintree];
        tr(ii).name = sprintf('Binary tree #%d',ii);
    end
else    % case (4)
    father = tree(varargin{:});
    father = set(father,'type','binary tree');
    % compute left and right nodes. arbitrarily chose the first son as
    % the left one
    no_nodes = get(father,'no_nodes');
    parent = get(father,'parent');
    l_node = zeros(1,no_nodes);
    r_node = zeros(1,no_nodes);
    for ii = 1:no_nodes
        if parent(ii)
            if l_node(parent(ii))
                r_node(parent(ii)) = ii;
            else
                l_node(parent(ii)) = ii;
            end
        end
    end
    % substitute in the class
    tr.l_node = l_node;
    tr.r_node = r_node;
    tr = class(tr,'bintree',father);
end