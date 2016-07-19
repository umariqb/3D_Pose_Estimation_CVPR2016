function names = variablenames(vsm)

% VARIABLENAMES retrieves the variable names of VSMATRIX.
% --------------------------
% names = variablenames(vsm)
% --------------------------
% Description: retrieves the variable names of VSMATRIX.
% Input:       {vsm} VSMATRIX instance.
% Output:      {names} variable names (cell row vector).

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 02-Aug-2006

% if no sampleset exists
names = vsm.variables(:).name';