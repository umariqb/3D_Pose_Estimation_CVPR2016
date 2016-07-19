function indicator = isnumeric(vr)

% ISNUMERIC checks for numeric variable(s).
% -------------------------
% indicator = isnumeric(vr)
% -------------------------
% Description: checks for numeric variable(s).
% Input:       {vr} variable instance(s).
% Output:      {indicator} binary flag, the same size as {vr}.

% © Liran Carmel
% Classification: Queries
% Last revision date: 18-Feb-2004

% initialize
indicator = zeros(size(vr));

% identify numeric variables
for ii = 1:length(indicator)
    if strcmp(vr(ii).level(1:7),'numeric')
        indicator(ii) = true;
    end
end