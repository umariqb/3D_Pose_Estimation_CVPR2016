function no_grps = nogroupings(ds)

% NOGROUPINGS number of groupings in dataset(s).
% -------------------------
% no_grps = nogroupings(ds)
% -------------------------
% Description: number of groupings in the dataset(s).
% Input:       {ds} dataset instance(s).
% Output:      {no_grps} array of the same dimension as {ds}, holding the
%                   number of groupings in each dataset instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 22-Sep-2004

% parse input
error(nargchk(1,1,nargin));

% substitute values
no_grps = zeros(size(ds));
for ii = 1:numel(ds)
    no_grps(ii) = ds(ii).no_groupings;
end