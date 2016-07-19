function no_factors = nofactors(lt)

% NOFACTORS retrieves the number of factors in LINTRANS.
% --------------------------
% no_factors = nofactors(lt)
% --------------------------
% Description: retrieves the number of variables in LINTRANS.
% Input:       {lt} LINTRANS instance(s).
% Output:      {no_factors} number of factors in each of the instances
%                   in {lt}. It has the same dimensions as {lt}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 13-jan-2005

% initialize
no_factors = zeros(size(lt));

% loop on all instances
for ii = 1:numel(lt)
    no_factors(ii) = get(lt(ii),'no_factors');
end