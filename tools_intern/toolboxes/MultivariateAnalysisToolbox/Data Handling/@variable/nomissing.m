function nom = nomissing(vr)

% NOMISSING retrieves the number of missing values.
% -------------------
% nom = nomissing(vr)
% -------------------
% Description: computes the number of missing values.
% Input:       {vr} instance of the variable class.
% Output:      {nom} number of missing missing values in the data.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 30-Aug-2004

nom = vr.no_missing;