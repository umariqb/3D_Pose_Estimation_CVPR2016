function list = leavesunder(tr,node)

% LEAVESUNDER lists the leaves that are descendants of a particular node.
% ----------------------------
% list = leavesunder(tr, node)
% ----------------------------
% Description: lists the leaves that are descendants of a particular node.
% Input:       {tr} TREE instance.
%              {node} the node whose underlying leaves we are seeking.
% Output:      {list} list of leaves under {node}.

% © Liran Carmel
% Classification: Tree structure
% Last revision date: 14-Mar-2006

% parse input - CHKVAR is done in DESCENDANTS
error(nargchk(2,2,nargin));

% find descendants of {node}
list = descendants(tr,node);

% intersect descendant of {node} with the leaves
list = intersect(list,leaves(tr));