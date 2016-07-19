function r = code2rank(code)

% CODE2RANK finds the rank of a DAG-code.
% -------------------
% r = code2rank(code)
% -------------------
% Description: finds the rank of a DAG-code [Steinsky B. (2003)
%              Soft. Computing 7: 350-356].
% Input:       {code} a DAG-code. For a digraph with {n} nodes, a DAG-code
%                   is an (n-1)-tuple of sets of nodes.
% Output:      {r} the rank.

% © Liran Carmel
% Classification: Computations
% Last revision date: 20-Mar-2008

% find accumulated code
n = length(code) + 1;

% initialize
r = 0;      % rank in the paper
un = [];    % union in the paper

% compute rank
for ss = 1:(n-1)
    
    % reset variables
    nu = length(un);
    zz = 0;
    rk = 0;
    X = [];
    Y = [];
    
    % first loop
    for xx = 1:n
        if any(un == xx)
            zz = zz + 1;
            if any(code{ss} == xx)
                X = union(X,zz);
            end
        else
            if any(code{ss} == xx)
                Y = union(Y,xx-zz);
            end
        end
    end
    
    % compute rk
    for kk = nu:ss
        rk = rk + cn(kk,ss,n) * nchoosek(n-nu,kk-nu);
    end
    rk = rk * subset2lexrank(X,nu);
    if length(Y) >= 1
        for kk = nu:(nu+length(Y)-1)
            rk = rk + cn(kk,ss,n) * nchoosek(n-nu,kk-nu);
        end
    end
    rk  = rk + ksubset2lexrank(Y,n-nu) * cn(nu+length(Y),ss,n);
    un = union(un,code{ss});
    r = r + rk;
    
end