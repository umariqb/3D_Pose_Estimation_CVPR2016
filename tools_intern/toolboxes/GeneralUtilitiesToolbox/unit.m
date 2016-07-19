function vec_norm = unit(vec,p)

% UNIT returnes the unit vector.
% -----------------------
% vec_norm = unit(vec, p)
% -----------------------
% Description: returnes the unit vector.
% Input:       {vec} is any vector.
%              {p} is the Minkowsky parameter to calculate the norm.
% Output:      {vec_norm} is the normalized vector.

% © Liran Carmel
% Classification: Vector manipulations
% Last revision date: 01-Mar-2004

% parse input line
if nargin == 1
    p = 2;
end

% get normalized vector
n = norm(vec,p);
vec_norm = vec / n;