function mnmx = minmax(x,dim)

% MINMAX calculate the minimal and maximal values of given data.
% ---------------------
% mnmx = minmax(x, dim)
% ---------------------
% Description: calculates the minimal and maximal values of given data.
% Input:       {x} any numeric data (scalar, vector, matrix).
%              <{dim}> if {x} is a matrix of size m-by-n, then MINMAX works
%                   by default along the rows, thus obtaining {mnmx} of
%                   size m-by-2. This can be changes by specifying {dim},
%                   which is the direction alnog which the calculation is
%                   carried (def=2).
% Output:      {mnmx} the minimal and maximal values of each row (or
%                   column) in {x}. If {x} is of size m-by-n, then
%                   MINMAX(x,1) yields a 2-by-n matrix, while MINMAX(x,2)
%                   yields an m-by-2 one.

% © Liran Carmel
% Classification: Information extraction
% Last revision date: 06-Feb-2004

% verify input parameters
error(nargchk(1,2,nargin));
if nargin == 1
    dim = 2;
end

% if {x} is a vector, {dim} may be misleading
[msg is_vector indctr] = chkvar(x,{},'vector');
if is_vector
    mn = min(x);
    mx = max(x);
else
    mn = min(x,[],dim);
    mx = max(x,[],dim);
end

% substitute in {mnmx}
if dim == 1
    mnmx = [mn ; mx];
else
    mnmx = [mn mx];
end