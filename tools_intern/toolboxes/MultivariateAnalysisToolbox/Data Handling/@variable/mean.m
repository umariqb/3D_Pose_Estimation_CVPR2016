function m = mean(vr)

% MEAN retrieves the sample mean of variable(s).
% ------------
% m = mean(vr)
% ------------
% Description: retrieves the sample mean of variable(s).
% Input:       {vr} variable instance(s).
% Output:      {m} sample mean values in each of the instances in
%                   {vr}. If {vr} is of length {n}, than {m} will also be
%                   of length {n}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 02-Sep-2004

% initialize
m = zeros(size(vr));

% loop on all instances
for ii = 1:numel(vr)
    m(ii) = vr(ii).mean.sample;
end