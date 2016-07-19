function H = entropy(p)

% ENTROPY computes the entropy of a distribution.
% --------------
% H  = entropy(p)
% --------------
% Description: computes the entropy of a distribution.
% Input:       {p} is the discrete distibution. For two-element
%                   distribution, it suffices to supply with only one of
%                   the elements.
% Output:      {H} is the entropy value (in bits).

% © Liran Carmel
% Classification: Basic functions
% Last revision date: 29-Dec-2006

% check number of argumesnts
error(nargchk(1,1,nargin));

% check input
if length(p) == 1
    p = [p 1-p];
end
if abs(sum(p) - 1) > 1e-15
    error('Probability function is not normalized');
end

% calculate entropy
warning off
H = -p.*log2(p);
warning on
H = nansum(H);
