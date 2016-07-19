function list = ancestors(tr,node)

% ANCESTORS finds the sequence of ancestors of a specifed node.
% --------------------------
% list = ancestors(tr, node)
% --------------------------
% Description: finds the sequence of ancestors of a specifed node.
% Input:       {tr} tree instance.
%              {node} the node to compute the ancestors of.
% Output:      {list} sequence of ancestors of the node: the node itself,
%                   his direct parent, ..., the root.

% © Liran Carmel
% Classification: Tree structure
% Last revision date: 18-May-2006

% parse input
error(nargchk(2,2,nargin));
error(chkvar(tr,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(node,'integer',...
    {'scalar',{'greaterthan',0},{'lowereq',get(tr,'no_nodes')}},...
    {mfilename,inputname(2),2}));

% return in a trivial case
if node == root(tr)
    list = node;
    return;
end

% extract information
pa = get(tr,'parent');

% initialize
list = node;  % list of nodes to be included in the new tree

% recursively find parents of {node}
parent = pa(node);
while parent
    list = [list parent];
    parent = pa(parent);
end