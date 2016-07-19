function indicator = iscomplete(vr)

% ISCOMPLETE checks for complete variable(s).
% --------------------------
% indicator = iscomplete(vr)
% --------------------------
% Description: checks for complete variable(s), i.e., variables with no
%              missing data.
% Input:       {vr} variable instance(s).
% Output:      {indicator} binary flag, the same size as {vr}.

% © Liran Carmel
% Classification: Queries
% Last revision date: 26-Feb-2004

% initialize
indicator = zeros(size(vr));

% identify numeric variables
for ii = 1:length(indicator)
    if vr(ii).no_missing == 0
        indicator(ii) = true;
    end
end