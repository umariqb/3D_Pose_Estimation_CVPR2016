function [trr, nodes] = addedge(varargin)

% ADDEDGE adds an edge to a binary tree.
% --------------------------------------------------
% [trr nodes] = addedge(tr, sib, p_name, p_val, ...)
% --------------------------------------------------
% Description: adds an edge, that is, two new nodes. The edge is leading
%              into {e}, and is originating from pa(e).
% Input:       {tr} BINTREE instance.
%              {sib} sibling of {e}.
%              <{p_name},{p_val}> pairs of properties of {e} and pa(e).
%                   Currently supported are 'node_name' or 'node_mass'. The
%                   order is always [pa(e) e].
% Output:      {trr} new BINTREE.
%              {nodes} indices of [pa(e) e].

% © Liran Carmel
% Classification: Transformations
% Last revision date: 17-Mar-2006

% parse input
[tr sib names masses] = parseInput(varargin{:});

% by convention, the new nodes are now
no_nodes = nonodes(tr);
nodes = no_nodes + [1 2];

% discriminate between two cases. (i) the new edge is internal to the tree.
% (ii) the new edge is external, namely the new node pa(e) is the new root
% of the tree.
pa = [get(tr,'parent') 0 no_nodes+1];
l_node = [get(tr,'l_node') sib 0];
r_node = [get(tr,'r_node') nodes(2) 0];
if sib ~= root(tr)
    % the new node is internal to the tree
    pa(no_nodes+1) = pa(sib);
    if l_node(pa(sib)) == sib
        l_node(pa(sib)) = nodes(1);
    else
        r_node(pa(sib)) = nodes(1);
    end
end
pa(sib) = nodes(1);
trr = bintree('parent',pa);
trr = set(trr,'l_node',l_node,'r_node',r_node);

% update node names and masses
node_name = [get(tr,'node_name') names];
node_mass = [get(tr,'node_mass') masses];
trr = set(trr,'node_name',node_name,'node_mass',node_mass);

% modify customized fields
cnames = cfieldnames(tr);
for ii = 1:length(cnames)
    f_val = [getcfield(tr,cnames{ii}) cell(1,2)];
    trr = setcfield(trr,cnames{ii},f_val);
end

% #########################################################################
function [tr, sib, names, masses] = parseInput(varargin)

% PARSEINPUT parses input line.
% --------------------------------------------
% [tr sib names masses] = parseInput(varargin)
% --------------------------------------------
% Description: parses the input line.
% Input:       {varargin} original input line.
% Output:      {tr} binary tree.
%              {sib} sibling node to {e}.
%              {names} names of {pa(e),e}.
%              {masses} mass of [pa(e) e].

% number of arguments
error(nargchk(2,inf,nargin));

% first argument is always the bintree
error(chkvar(varargin{1},{},'scalar',{'mfilename','',1}));
tr = varargin{1};

% second argument is the sibling
error(chkvar(varargin{2},'integer',...
    {'scalar',{'greaterthan',0},{'eqlower',nonodes(tr)}},...
    {'mfilename','',2}));
sib = varargin{2};

% defaults
no_nodes = nonodes(tr);
names = {sprintf('Node #%d',no_nodes+2),sprintf('Node #%d',no_nodes+1)};
masses = [1 1];

% loop on properties
for ii = 3:2:nargin
    errmsg = {mfilename,'',ii+1};
    switch str2keyword(varargin{ii},9)
        case 'node_name'   % property: node_name
            error(chkvar(varargin{ii+1},'cell',...
                {'vector',{'length',2}},errmsg));
            names = varargin{ii+1};
        case 'node_mass'   % property: node_mass
            error(chkvar(varargin{ii+1},'double',...
                {'vector',{'length',2}},errmsg));
            masses = varargin{ii+1};
        otherwise
            error('unrecognized property: %s',char(varargin{ii}));
    end
end