function indicator = isordinal(vr)

% ISORDINAL checks for ordinal variable(s).
% -------------------------
% indicator = isordinal(vr)
% -------------------------
% Description: checks for ordinal variable(s).
% Input:       {vr} variable instance(s).
% Output:      {indicator} binary flag, the same size as {vr}.

% © Liran Carmel
% Classification: Queries
% Last revision date: 10-Feb-2004

% initialize
indicator = zeros(size(vr));

% identify numeric variables
for ii = 1:length(indicator)
    if strcmp(vr(ii).level,'ordinal')
        indicator(ii) = true;
    end
end