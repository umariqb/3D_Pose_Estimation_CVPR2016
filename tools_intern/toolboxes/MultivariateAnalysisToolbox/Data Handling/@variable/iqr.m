function r = iqr(vr)

% IQR computes the inter-quartile range of variable(s).
% -----------
% r = iqr(vr)
% -----------
% Description: computes the inter-quartile range of variable(s).
% Input:       {vr} variable instance(s).
% Output:      {r} the inter-quantile range, the distance between the 0.25
%                   quantile and the 0.75 quantile.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 10-Feb-2005

% initialize
r = zeros(size(vr));

% loop on all instances
for ii = 1:numel(vr)
    r(ii) = iqr(vr(ii).data);
end