function div = ldiv(p,q)

% LDIV computes the L-divergence between distributions p and q.
% ----------------
% div = ldiv(p, q)
% ----------------
% Description: computes the L-divergence between distributions p and q (for
%              definition of this measure, see Lin, J. (1991) Divergence
%              measures based on the shannon entropy. IEEE Trans.
%              Information Theory 37, 145-151.
% Input:       {p} first discrete distibution.
%              {q} second discrete distibution.
% Output:      {div} value of the divergence.

% © Liran Carmel
% Classification: Basic functions
% Last revision date: 06-Dec-2006

div = kdiv(p,q) + kdiv(q,p);