function miss = computemissing(vr)

% COMPUTEMISSING finds the number of missing values.
% -------------------------
% miss = computemissing(vr)
% -------------------------
% Description: recomputes the number of missing values in the given
%              samples.
% Input:       {vr} instance of the variable class.
% Output:      {miss} number of missing values in the data.

% © Liran Carmel
% Classification: Update functions
% Last revision date: 26-Aug-2004

% the number of missing values is set automatically to zero, when there
% is no data.
miss = vr.no_samples - length(nanless(vr));