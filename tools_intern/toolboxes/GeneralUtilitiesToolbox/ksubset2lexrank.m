function r = ksubset2lexrank(T,n)

% KSUBSET2LEXRANK finds the lexicographic rank of a k-subset T.
% -------------------------
% r = ksubset2lexrank(T, n)
% -------------------------
% Description: finds the lexicographic rank of a k-subset T from (1,...,n).
%              The algorithm is based on Algorithm 2.7 in Donald L. Kreher
%              & Douglas R. Stinson, Combinatorial Algorithms: generation,
%              enumeration, and search, CRC Press, 1999.
% Input:       {T} a k-subset from (1, ..., n).
%              {n} defines the maximum possible integer in {T}.
% Output:      {r} is the lexicographical rank of {T}.

% © Liran Carmel
% Classification: Combinatorial Algorithms
% Last revision date: 20-Mar-2008

% get the size of the subset
k = length(T);

% apply the algorithm
T = [0 T];
r = 0;
for ii = 1:k
    for jj = (T(ii)+1):(T(ii+1)-1)
        r = r + nchoosek(n-jj,k-ii);
    end
end