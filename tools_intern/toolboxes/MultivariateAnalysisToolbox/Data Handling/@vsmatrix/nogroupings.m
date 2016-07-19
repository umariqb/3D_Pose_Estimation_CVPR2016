function no_grps = nogroupings(vsm)

% NOGROUPINGS retrieves the number of groupings in vsmatrix.
% --------------------------
% no_grps = nogroupings(vsm)
% --------------------------
% Description: retrieves the number of groupings in vsmatrix.
% Input:       {vsm} vsmatrix instance(s).
% Output:      {no_grps} number of groupings in each of the instances
%                   in {vsm}. It has the same dimensions as {vsm}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 08-Oct-2004

% initialize
no_grps = zeros(size(vsm));

% loop on all instances
for ii = 1:numel(vsm)
    no_grps(ii) = length(vsm(ii).groupings);
end