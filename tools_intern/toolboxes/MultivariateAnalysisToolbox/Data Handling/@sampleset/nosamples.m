function no_samples = nosamples(ss)

% NOSAMPLES finds the number of samples in samplesets.
% --------------------------
% no_samples = nosamples(ss)
% --------------------------
% Description: finds the number of samples samplesets.
% Input:       {ss} sampleset instance(s).
% Output:      {no_samples} number of samples in each of the instances in
%                   {ss}. It has the same dimensions as {ss}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 02-Sep-2004

% initialize
no_samples = zeros(size(ss));

% loop on all instances
for ii = 1:numel(ss)
    no_samples(ii) = ss(ii).no_samples;
end