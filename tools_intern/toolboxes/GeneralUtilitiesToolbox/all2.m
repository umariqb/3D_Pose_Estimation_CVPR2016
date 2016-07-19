function flag = all2(x)

% ALL2 returns 1 if all elements in matrix X are true.
% --------------
% flag = all2(x)
% --------------
% Description: returns 1 if all elements in matrix X are true.
% Input:       {x} is a matrix (or a vector or a scalar).
% Output:      {flag} is true if all elements of {x} are true.

% © Liran Carmel
% Classification: Information extraction
% Last revision date: 26-Mar-2008

flag = all(all(x));