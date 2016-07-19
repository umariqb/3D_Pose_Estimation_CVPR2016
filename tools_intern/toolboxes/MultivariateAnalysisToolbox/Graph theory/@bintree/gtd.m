function dst = gtd(tr,nodeA,nodeB)

% GTD computes the graph theoretic distance between two nodes.
% ---------------------------
% dst = gtd(tr, nodeA, nodeB)
% ---------------------------
% Description: computes the graph theoretic distance between two nodes.
% Input:       {tr} BINTREE instance.
%              {nodeA} first node.
%              {nodeB} second node.
% Output:      {dst} graph theoretic distance.

% © Liran Carmel
% Classification: Computations
% Last revision date: 17-Mar-2006

% parse input
error(nargchk(3,3,nargin));

% find the ancestors of both nodes
listA = ancestors(tr,nodeA);
listB = ancestors(tr,nodeB);

% find where the LCA is located in both lists
common = lca(tr,[nodeA nodeB]);
dst = find(listA==common) + find(listB==common);