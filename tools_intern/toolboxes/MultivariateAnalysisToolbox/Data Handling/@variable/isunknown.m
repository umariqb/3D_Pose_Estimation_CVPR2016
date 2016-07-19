function indicator = isunknown(vr)

% ISUNKNOWN checks for unknown variable(s).
% -------------------------
% indicator = isunknown(vr)
% -------------------------
% Description: checks for unknown variable(s).
% Input:       {vr} variable instance(s).
% Output:      {indicator} binary flag, the same size as {vr}.

% © Liran Carmel
% Classification: Queries
% Last revision date: 10-Feb-2004

% initialize
indicator = zeros(size(vr));

% identify numeric variables
for ii = 1:length(indicator)
    if strcmp(vr(ii).level,'unknown')
        indicator(ii) = true;
    end
end