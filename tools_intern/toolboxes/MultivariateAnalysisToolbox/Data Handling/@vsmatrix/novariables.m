function no_variables = novariables(vsm)

% NOVARIABLES retrieves the number of variables in vsmatrix.
% -------------------------------
% no_variables = novariables(vsm)
% -------------------------------
% Description: retrieves the number of variables in vsmatrix.
% Input:       {vsm} vsmatrix instance(s).
% Output:      {no_variables} number of variables in each of the instances
%                   in {vsm}. It has the same dimensions as {vsm}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 02-Sep-2004

% initialize
no_variables = zeros(size(vsm));

% loop on all instances
for ii = 1:numel(vsm)
    no_variables(ii) = get(vsm(ii),'no_rows');
end