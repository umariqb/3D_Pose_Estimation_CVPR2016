function cval = cn(k,v,n)

% CN computes an auxiliary function required for DAG codes.
% ------------------
% cval = cn(k, v, n)
% ------------------
% Description: computes an auxiliary function required for DAG codes
%              [Steinsky B. (2003) Soft. Computing 7: 350-356. c_n is
%              defined on the bottom right-column of page 352].
% Input:       {k} size of k-subset.
%              {v} size of set.
%              {n} number of nodes in the DAG.
% Output:      {cval} computed value.

% © Liran Carmel
% Classification: Computations
% Last revision date: 20-Mar-2008

% recursion-stop condition
if v == n-1
    cval = 1;
    return;
end

% recursion
tmp = 0;
for nu = k:(v+1)
    tmp = tmp + nchoosek(n-k,nu-k) * cn(nu,v+1,n);
end
cval = 2^k * tmp;