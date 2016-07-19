function m = minmax(vr)

% MINMAX retrieves the sample minmax of variable(s).
% --------------
% m = minmax(vr)
% --------------
% Description: retrieves the sample minmax of variable(s).
% Input:       {vr} variable instance(s).
% Output:      {m} sample minmax values in each of the instances in
%                   {vr}. If {vr} is of length {n}, than {m} will be a
%                   2-by-{n} matrix.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 30-Aug-2004

% initialize
m = zeros(2,length(vr));

% loop on all instances
for ii = 1:length(vr)
    m(:,ii) = vr(ii).minmax.sample';
end