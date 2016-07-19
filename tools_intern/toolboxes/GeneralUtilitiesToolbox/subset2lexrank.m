function r = subset2lexrank(T,n)

% SUBSET2LEXRANK finds the lexicographic rank of a subset T \in (1,...,n).
% ------------------------
% r = subset2lexrank(T, n)
% ------------------------
% Description: finds the lexicographic rank of a subset T \in (1,...,n).
%              The algorithm is based on Algorithm 2.1 in Donald L. Kreher
%              & Douglas R. Stinson, Combinatorial Algorithms: generation,
%              enumeration, and search, CRC Press, 1999.
% Input:       {T} a subset of (1, ..., n).
%              {n} defines the maximum possible integer in {T}.
% Output:      {r} is the lexicographical rank of {T}.

% © Liran Carmel
% Classification: Combinatorial Algorithms
% Last revision date: 19-Mar-2008

% special case
if n == 0
    r = 0;
    return;
end

% make a binary vector with 1 where the elements of T are
binvec = zeros(1,n);
binvec(T) = 1;

% rank
r = bin2dec(char(48+binvec));