function no_samples = nosamples(lt)

% NOSAMPLES retrieves the number of samples in LINTRANS.
% --------------------------
% no_samples = nosamples(lt)
% --------------------------
% Description: retrieves the number of variables in LINTRANS.
% Input:       {lt} LINTRANS instance(s).
% Output:      {no_samples} number of samples in each of the instances
%                   in {lt}. It has the same dimensions as {lt}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 13-jan-2005

% initialize
no_samples = zeros(size(lt));

% loop on all instances
for ii = 1:numel(lt)
    no_samples(ii) = get(lt(ii),'no_samples');
end