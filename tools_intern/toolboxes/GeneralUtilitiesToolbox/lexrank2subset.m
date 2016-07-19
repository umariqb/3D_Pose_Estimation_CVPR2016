function T = lexrank2subset(r,n)

% LEXRANK2SUBSET finds the subset T \in (1,...,n) whose rank is {r}.
% ------------------------
% T = lexrank2subset(r, n)
% ------------------------
% Description: finds the subset T \in (1,...,n) whose lexicographic rank is
%              {r}. The algorithm is based on Algorithm 2.2 in Donald L.
%              Kreher & Douglas R. Stinson, Combinatorial Algorithms:
%              generation, enumeration, and search, CRC Press, 1999.
% Input:       {r} is the lexicographical rank of {T}.
%              {n} defines the maximum possible integer in {T}.
% Output:      {T} a subset of (1, ..., n).

% © Liran Carmel
% Classification: Combinatorial Algorithms
% Last revision date: 20-Mar-2008

% make a binary vector with 1 where the elements of T are
binvec = logical(dec2bin(r,n) - 48);

% compute T
S = 1:n;
T = S(binvec);