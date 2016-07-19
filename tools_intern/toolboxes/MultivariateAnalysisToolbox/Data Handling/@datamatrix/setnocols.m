function dm = setnocols(dm,no_cols)

% SETNOCOLS sets the number of columns in the datamatrix.
% ---------------------------
% dm = setnocols(dm, no_cols)
% ---------------------------
% Description: sets the number of columns in the datamatrix.
% Input:       {dm} datamatrix instance(s).
%              {no_cols} number of columns. If {dm} is not a scalar,
%                   {no_cols} should either match in dimensions, or be a
%                   common scalar to all instances.
% Output:      {dm} updated instance(s).
% Warning:     The field 'no_cols' is read-only and should not be changed
%              by the user. This function allows derived object to control
%              this field.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 07-Jan-2005

% compare dimensions of {dm} and {no_cols}
if isscalar(no_cols)
    no_cols = no_cols*ones(size(dm));
end
if any(size(no_cols) ~= size(dm))
    error('%s and %s should match in size',inputname(1),inputname(2));
end

% substitute no_cols
for ii = numel(dm)
    dm(ii).no_cols = no_cols(ii);
end