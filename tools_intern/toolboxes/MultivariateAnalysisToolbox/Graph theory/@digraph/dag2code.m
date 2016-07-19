function code = dag2code(dg)

% DAG2CODE finds the DAG-code of a DAG.
% -------------------
% code = dag2code(dg)
% -------------------
% Description: finds the DAG-code of a DAG [Steinsky B. (2003) Soft.
%              Computing 7: 350-356]. For speed, I don't use the regular
%              DIGRAPH functions to find leaves, parents, etc.
% Input:       {dg} instance of DIGRAPH.
% Output:      {code} codes matching the digraphs in {dg}. A code of a
%                   digraph with {n} nodes is an (n-1)-tuple of sets of
%                   nodes. If the digraph is not a DAG, a code of -1 is
%                   returned.

% © Liran Carmel
% Classification: Computations
% Last revision date: 18-Jan-2008

% initialize
no_nodes = nonodes(dg);
code = cell(1,no_nodes-1);
nodeIDs = 1:no_nodes;

% find arrow directions
D = get(dg,'thd');

% start loop
for k = (no_nodes-1):-1:1
    % compute code{k}
    u = min(leaves(D));
    code{k} = nodeIDs(D(u,:)<0);
    % remove one node from the graph
    D(u,:) = [];
    D(:,u) = [];
    nodeIDs(u) = [];
end

% #########################################################################
function idx = leaves(D)

% LEAVES finds the leaves of the graph from the THD matrix.
% I prefer to avoid using the official LEAVES function of DIGRPAH, because
% the current implementation is skinny and fast.
deg = sum(D>0,2);
idx = find(deg==0);