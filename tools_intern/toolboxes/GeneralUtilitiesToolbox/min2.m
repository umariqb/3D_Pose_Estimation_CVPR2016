function mn = min2(x)

% MIN2 returnes the minimal element in a matrix.
% ------------
% mn = min2(x)
% ------------
% Description: returns the minimal element in a matrix.
% Input:       {x} is a matrix (or a vector or a scalar).
% Output:      {mn} is the minimal entry of {x}.

% © Liran Carmel
% Classification: Information extraction
% Last revision date: 01-Apr-2004

mn = min(min(x));