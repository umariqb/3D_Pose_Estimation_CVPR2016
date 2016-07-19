function node = lca(tr,nodes)

% LCA finds the last common ancestor of a list of nodes.
% ---------------------
% node = lca(tr, nodes)
% ---------------------
% Description: finds the last common ancestor of a list of nodes.
% Input:       {tr} tree instance.
%              {nodes} list of nodes whose common ancestor we seek.
% Output:      {node} ID of the last common ancestor. If {nodes} is empty,
%                   so is {node}. If {nodes} contain a single node, it is
%                   considered as a parent of itself.

% © Liran Carmel
% Classification: Tree structure
% Last revision date: 06-Dec-2004

% parse input
error(nargchk(2,2,nargin));
error(chkvar(tr,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(nodes,'integer','vector',{mfilename,inputname(2),2}));

% return in a trivial case
if isempty(nodes)
    node = [];
    return;
end

% topological order is required for this
[tr idx] = order(tr,'topological');
nodes = idx(nodes);

% initialize. Sorting is required here in case that there is only one item
% in {nodes}, and the INTERSECT command, which also makes sorting, is never
% executed.
list = sort(ancestors(tr,nodes(1)));

% now get temporary list for each additional node, and merge lists
for ii = 2:length(nodes)
    % create least for nodes(ii)
    tmp_list = ancestors(tr,nodes(ii));
    % merge with overall list
    list = intersect(list,tmp_list);
end

% get final answer
node = find(idx==list(end));