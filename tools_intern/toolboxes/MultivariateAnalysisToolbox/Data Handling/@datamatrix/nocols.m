function no_cols = nocols(dm)

% NOCOLS retrieves the number of columns in DATAMATRIX instances.
% --------------------
% no_cols = nocols(dm)
% --------------------
% Description: retrieves the number of columnss in DATAMATRIX instances.
% Input:       {dm} DATAMATRIX instance(s).
% Output:      {no_cols} number of columns in each of the instances in
%                   {dm}. It has the same dimensions as {dm}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 08-Nov-2006

% initialize
no_cols = zeros(size(dm));

% loop on all instances
for ii = 1:numel(dm)
    no_cols(ii) = dm(ii).no_cols;
end