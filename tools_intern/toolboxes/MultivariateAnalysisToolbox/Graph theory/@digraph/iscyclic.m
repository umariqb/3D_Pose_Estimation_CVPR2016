function flag = iscyclic(dg)

% ISCYCLIC finds whether a DIGRAPH is cyclic or not.
% -------------------
% flag = iscyclic(dg)
% -------------------
% Description: finds whether a DIGRAPH is cyclic or not.
% Input:       {dg} array of DIGRAPHs.
% Output:      {flag} TRUE if the digraph is cyclic, FALSE if it is DAG.
%                   It's size is the same as {dg}.

% © Liran Carmel
% Classification: Computations
% Last revision date: 16-Jan-2008

% initialize
flag = false(size(dg));

% loop on all instances
for ii = 1:numel(dg)
    % make a matrix D, with Dij=1 indicating an edge from i to j
    D = get(dg(ii),'thd');
    D(D>0) = 1;
    D(D<0) = 0;
    % check cycles
    flag(ii) = ~graphisdag(D);
end