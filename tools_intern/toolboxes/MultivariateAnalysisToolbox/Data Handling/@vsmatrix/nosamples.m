function no_samples = nosamples(vsm)

% NOSAMPLES retrieves the number of samples in vsmatrix.
% ---------------------------
% no_samples = nosamples(vsm)
% ---------------------------
% Description: retrieves the number of samples in vsmatrix.
% Input:       {vsm} vsmatrix instance(s).
% Output:      {no_samples} number of samples in each of the instances in
%                   {vsm}. It has the same dimensions as {vsm}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 02-Sep-2004

% initialize
no_samples = zeros(size(vsm));

% loop on all instances
for ii = 1:numel(vsm)
    no_samples(ii) = get(vsm(ii),'no_cols');
end