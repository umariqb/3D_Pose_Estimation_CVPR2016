function no_samples = nosamples(gr)

% NOSAMPLES finds the number of samples in grouping.
% --------------------------
% no_samples = nosamples(gr)
% --------------------------
% Description: finds the number of samples in grouping.
% Input:       {gr} grouping instance(s).
% Output:      {no_samples} number of samples in each of the instances in
%                   {gr}. It has the same dimensions as {gr}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 06-Dec-2004

% initialize
no_samples = zeros(size(gr));

% loop on all instances
for ii = 1:numel(gr)
    no_samples(ii) = gr(ii).no_samples;
end