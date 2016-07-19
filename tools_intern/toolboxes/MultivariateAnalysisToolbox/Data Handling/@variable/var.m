function v = var(vr)

% VAR retrieves the sample variance of variable(s).
% -----------
% v = var(vr)
% -----------
% Description: retrieves the sample variance of variable(s).
% Input:       {vr} variable instance(s).
% Output:      {v} sample variance values in each of the instances in
%                   {vr}. If {vr} is of length {n}, than {v} will also be
%                   of length {n}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 02-Sep-2004

% initialize
v = zeros(size(vr));

% loop on all instances
for ii = 1:numel(vr)
    v(ii) = vr(ii).variance.sample;
end