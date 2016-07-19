function flag = any2(x)

% ANY2 returns 1 if any element in matrix X is true.
% --------------
% flag = any2(x)
% --------------
% Description: returns 1 if any element in matrix X is true.
% Input:       {x} is a matrix (or a vector or a scalar).
% Output:      {flag} is true if any element of {x} is true.

% © Liran Carmel
% Classification: Information extraction
% Last revision date: 26-Mar-2008

flag = any(any(x));