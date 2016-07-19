function mx = max2(x)

% MAX2 returnes the maximal element in a matrix.
% ------------
% mx = max2(x)
% ------------
% Description: returns the maximal element in a matrix.
% Input:       {x} is a matrix (or a vector or a scalar).
% Output:      {mx} is the maximal entry of {x}.

% © Liran Carmel
% Classification: Information extraction
% Last revision date: 01-Apr-2004

mx = max(max(x));