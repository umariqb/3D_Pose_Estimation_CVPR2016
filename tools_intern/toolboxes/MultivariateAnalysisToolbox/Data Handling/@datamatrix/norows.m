function no_rows = norows(dm)

% NOROWS retrieves the number of rows in DATAMATRIX instances.
% --------------------
% no_rows = norows(dm)
% --------------------
% Description: retrieves the number of rows in DATAMATRIX instances.
% Input:       {dm} DATAMATRIX instance(s).
% Output:      {no_rows} number of rows in each of the instances in {dm}.
%                   It has the same dimensions as {dm}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 08-Nov-2006

% initialize
no_rows = zeros(size(dm));

% loop on all instances
for ii = 1:numel(dm)
    no_rows(ii) = dm(ii).no_rows;
end