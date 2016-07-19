function dm = setnorows(dm,no_rows)

% SETNOROWS sets the number of rows in the datamatrix.
% ---------------------------
% dm = setnorows(dm, no_rows)
% ---------------------------
% Description: sets the number of rows in the datamatrix.
% Input:       {dm} datamatrix instance(s).
%              {no_rows} number of rows. If {dm} is not a scalar,
%                   {no_rows} should either match in dimensions, or be a
%                   common scalar to all instances.
% Output:      {dm} updated instance(s).
% Warning:     The field 'no_rows' is read-only and should not be changed
%              by the user. This function allows derived object to control
%              this field.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 07-Jan-2005

% compare dimensions of {dm} and {no_rows}
if isscalar(no_rows)
    no_rows = no_rows*ones(size(dm));
end
if any(size(no_rows) ~= size(dm))
    error('%s and %s should match in size',inputname(1),inputname(2));
end

% substitute no_rows
for ii = numel(dm)
    dm(ii).no_rows = no_rows(ii);
end