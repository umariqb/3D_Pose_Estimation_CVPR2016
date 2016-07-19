function m = min(vr)

% MIN retrieves the sample min of variable(s).
% -----------
% m = min(vr)
% -----------
% Description: retrieves the sample min of variable(s).
% Input:       {vr} variable instance(s).
% Output:      {m} sample min values in each of the instances in
%                   {vr}. If {vr} is of length {n}, than {m} will also be
%                   of length {n}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 30-Aug-2004

% initialize
m = zeros(size(vr));

% loop on all instances
for ii = 1:numel(vr)
    m(ii) = vr(ii).minmax.sample(1);
end