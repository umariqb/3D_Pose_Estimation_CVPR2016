function div = kl(p,q)

% KL computes the relative entropy.
% --------------
% div = kl(p, q)
% --------------
% Description: computes the relative entropy, or the Kulback-Leibner
%              divergence.
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
if abs(sum(p) - 1) > 1e-15 | abs(sum(q) - 1) > 1e-15
    error('Probability functions are not normalized');
end

% calculate divergence
warning('off','MATLAB:log:logOfZero');
div = p .* log2(p./q);
div(p==0) = 0;
warning('on','MATLAB:log:logOfZero');
if any(isnan(div))
   error('{q} is not absolutely continuous over {p}')
end
div = sum(div);