function s = std(vr)

% STD retrieves the sample standard deviation of variable(s).
% -----------
% s = std(vr)
% -----------
% Description: retrieves the sample standard deviation of variable(s).
% Input:       {vr} variable instance(s).
% Output:      {v} sample standard deviation values in each of the
%                   instances in {vr}. If {vr} is of length {n}, than {s}
%                   will also be of length {n}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 30-Aug-2004

s = sqrt(var(vr));