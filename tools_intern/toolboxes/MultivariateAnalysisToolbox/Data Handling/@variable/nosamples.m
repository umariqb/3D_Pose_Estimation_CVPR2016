function no_samples = nosamples(vr)

% NOSAMPLES retrieves the number of samples in variable.
% --------------------------
% no_samples = nosamples(vr)
% --------------------------
% Description: finds the number of samples in variable.
% Input:       {vr} variable instance(s).
% Output:      {no_samples} number of samples in each of the instances in
%                   {vr}. It has the same dimensions as {vr}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 02-Sep-2004

% initialize
no_samples = zeros(size(vr));

% loop on all instances
for ii = 1:numel(vr)
    vrii = instance(vr,num2str(ii));
    no_samples(ii) = vrii.no_samples;
end