function code = rank2code(r,n)

% RANK2CODE finds the DAG-code whose rank is {r}.
% ----------------------
% code = rank2code(r, n)
% ----------------------
% Description: finds the DAG-code whose rank is {r} [Steinsky B. (2003)
%              Soft. Computing 7: 350-356].
% Input:       {r} the rank.
%              {n} number of nodes in the DAG.
% Output:      {code} a DAG-code. For a digraph with {n} nodes, a DAG-code
%                   is an (n-1)-tuple of sets of nodes.

% © Liran Carmel
% Classification: Computations
% Last revision date: 20-Mar-2008

% initialize
code = cell(1,n-1);
sm = r;
un = [];
cardUn = 0;

% main loop
for ss = 1:(n-1)
    nu = length(un);
    rk = 0;
    for kk = nu:ss
        rk = rk + cn(kk,ss,n) * nchoosek(n-nu,kk-nu);
    end
    rankX = floor(sm/rk);
    sm = sm - rankX * rk;
    kk = nu;
    rk = 0;
    
    term = rk + cn(kk,ss,n) * nchoosek(n-nu,kk-nu);
    while term <= sm
        rk = term;
        kk = kk + 1;
        term = rk + cn(kk,ss,n) * nchoosek(n-nu,kk-nu);
    end
    rankY = floor( (sm-rk)/cn(kk,ss,n) );
    cardY = kk - nu;
    sm = sm - rk - rankY * cn(nu+cardY,ss,n);
    X = lexrank2subset(rankX,cardUn);
    Y = lexrank2ksubset(rankY,cardY,n-cardUn);
    zz = 0;
    
    for xx = 1:n
        if any(un == xx)
            zz = zz + 1;
            if any(X == zz)
                code{ss} = [code{ss} xx];
            end
        else
            if any(Y == xx-zz)
                code{ss} = [code{ss} xx];
            end
        end
    end
    
    un = [un Y];
    cardUn = length(un);
end