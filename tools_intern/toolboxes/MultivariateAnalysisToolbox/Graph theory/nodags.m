function N = nodags(no_nodes)

% NODAGS computes the number of DAGs with fixed number of nodes.
% --------------------
% N = nodags(no_nodes)
% --------------------
% Description: computes the number of DAGs with fixed number of nodes.
% Input:       {no_nodes} number of nodes.
% Output:      {N} Number of DAGs.

% © Liran Carmel
% Last revision date: 17-Jan-2008

N = 0;
for nu = 0:(no_nodes-1)
    N = N + b(no_nodes,nu,no_nodes-1);
end

function res = b(n,nu,s)

% stopping rule
if s==1
    if nu==0
        res = 1;
        return;
    elseif nu==1
        res = n;
        return;
    end
end

% recursion
res = 0;
for k=0:min(nu,s-1)
    res = res + 2^k * nchoosek(n-k,nu-k) * b(n,k,s-1);
end