function vec = forcerow(vec)

% FORCEROW ensures that a vector is a row-vector.
% -------------------
% vec = forcerow(vec)
% -------------------
% Description: ensures that a vector is a row-vector.
% Input:       {vec} any vector.
% Output:      {vec} row-vector.

% © Liran Carmel
% Classification: Vector manipulations
% Last revision date: 12-Jan-2006

vec = vec(:)';