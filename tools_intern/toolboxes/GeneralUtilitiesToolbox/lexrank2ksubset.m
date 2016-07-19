function T = lexrank2ksubset(r,k,n)

% LEXRANK2KSUBSET finds the k-subset T from (1,...,n) whose rank is {r}.
% ----------------------------
% T = lexrank2ksubset(r, k, n)
% ----------------------------
% Description: finds the k-subset T from (1,...,n) whose rank is {r}.
%              The algorithm is based on Algorithm 2.8 in Donald L. Kreher
%              & Douglas R. Stinson, Combinatorial Algorithms: generation,
%              enumeration, and search, CRC Press, 1999.
% Input:       {r} is the lexicographical rank of {T}.
%              {k} the cardinality of the k-subset.
%              {n} defines the maximum possible integer in {T}.
% Output:      {T} a k-subset from (1, ..., n).

% © Liran Carmel
% Classification: Combinatorial Algorithms
% Last revision date: 20-Mar-2008

% initialize
x = 1;
T = [];

% main loop
for ii = 1:k
    term = nchoosek(n-x,k-ii);
    while term <= r
        r = r - term;
        x = x + 1;
        term = nchoosek(n-x,k-ii);
    end
    T = [T x];
    x = x + 1;
end