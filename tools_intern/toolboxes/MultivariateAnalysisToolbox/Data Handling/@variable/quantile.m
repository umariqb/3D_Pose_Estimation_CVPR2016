function q = quantile(vr, p)

% QUANTILE computes the quantiles of variable(s).
% -------------------
% q = quantile(vr, p)
% -------------------
% Description: computes the quantiles of variable(s).
% Input:       {vr} variable instance(s).
%              {p} desired quantiles, a vector of values in the range
%                   [0 1].
% Output:      {q} desired quantiles.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 10-Feb-2005

% initialize
q = cell(size(vr));

% loop on all instances
for ii = 1:numel(vr)
    q{ii} = quantile(vr(ii).data,p);
end

% if {vr} is scalar, don't return a cell
if isscalar(vr)
    q = q{1};
end