function s = sum2(x)

% SUM2 returnes the sum of all elements of a matrix.
% -----------
% s = sum2(x)
% -----------
% Description: returns the sum of all elements of a matrix.
% Input:       {x} is a matrix (or a vector or a scalar).
% Output:      {s} is the sum of all entries of {x}.

% © Liran Carmel
% Classification: Information extraction
% Last revision date: 29-Mar-2004

s = sum(sum(x));