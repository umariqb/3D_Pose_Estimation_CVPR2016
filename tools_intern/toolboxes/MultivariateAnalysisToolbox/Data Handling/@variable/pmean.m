function m = pmean(vr)

% PMEAN retrieves the population mean of variable(s).
% -------------
% m = pmean(vr)
% -------------
% Description: retrieves the population mean of variable(s).
% Input:       {vr} variable instance(s).
% Output:      {m} populatin mean values in each of the instances in
%                   {vr}. If {vr} is of length {n}, than {m} will also be
%                   of length {n}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 02-Sep-2004

% initialize
m = zeros(size(vr));

% loop on all instances
for ii = 1:numel(vr)
    m(ii) = vr(ii).mean.population;
end