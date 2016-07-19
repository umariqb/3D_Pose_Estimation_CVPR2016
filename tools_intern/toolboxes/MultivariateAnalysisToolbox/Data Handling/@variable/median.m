function m = median(vr)

% MEDIAN retrieves the sample median of variable(s).
% --------------
% m = median(vr)
% --------------
% Description: retrieves the sample median of variable(s).
% Input:       {vr} variable instance(s).
% Output:      {m} sample median values in each of the instances in
%                   {vr}. {m} is of the same dimensions as {vr}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 13-Dec-2004

% initialize
m = zeros(size(vr));

% loop on all instances
for ii = 1:numel(vr)
    m(ii) = nanmedian(vr(ii).data);
end