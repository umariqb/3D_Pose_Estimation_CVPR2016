function dg = code2dag(code)

% CODE2DAG finds the DAG associated with a DAG-code.
% -------------------
% dg = code2dag(code)
% -------------------
% Description: finds the DAG associated with a DAG-code [Steinsky B. (2003)
%              Soft. Computing 7: 350-356]. For speed, I don't use the
%              regular DIGRAPH functions to find leaves, parents, etc.
% Input:       {code} a DAG-code. For a digraph with {n} nodes, a DAG-code
%                   is an (n-1)-tuple of sets of nodes.
% Output:      {dg} matching DIGRAPH.

% © Liran Carmel
% Classification: Computations
% Last revision date: 18-Jan-2008

% find accumulated code
no_nodes = length(code) + 1;
acode = cell(1,no_nodes-1);
acode{1} = code{1};
for ii=2:(no_nodes-1)
    acode{ii} = union(acode{ii-1},code{ii});
end

% initialize
S = 1:no_nodes;
D = zeros(no_nodes);

% main loop
for k = (no_nodes-1):-1:1
    s = min(setdiff(S,acode{k}));
    D(code{k},s) = 1;
    D(s,code{k}) = -1;
    S(S==s) = [];
end

dg = digraph('thd',D);