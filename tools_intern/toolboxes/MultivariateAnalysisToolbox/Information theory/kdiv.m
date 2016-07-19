function div = kdiv(p,q)

% KDIV computes the K-divergence between distributions p and q.
% ----------------
% div = kdiv(p, q)
% ----------------
% Description: computes the K-divergence between distributions p and q (for
%              definition of this measure, see Lin, J. (1991) Divergence
%              measures based on the shannon entropy. IEEE Trans.
%              Information Theory 37, 145-151.
% Input:       {p} first discrete distibution.
%              {q} second discrete distibution.
% Output:      {div} value of the divergence.

% © Liran Carmel
% Classification: Basic functions
% Last revision date: 20-Oct-2006

% check number of argumesnts
error(nargchk(2,2,nargin));

% check input
if length(p) ~= length(q)
   error('Lengths of {p} and {q} are not the same')
end
if abs(sum(p) - 1) > 1e-15 || abs(sum(q) - 1) > 1e-15
    error('Probability functions are not normalized');
end

% calculate divergence
warning('off','MATLAB:log:logOfZero')
warning('off','MATLAB:divideByZero');
div = p .* log2(2 * p ./ (p+q));
div(p==0) = 0;
warning('on','MATLAB:divideByZero');
warning('on','MATLAB:log:logOfZero');
if any(isnan(div))
   error('{q} is not absolutely continuous over {p}')
end
div = sum(div);