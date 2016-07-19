function mn = computemean(vr)

% COMPUTEMEAN calculates sample mean.
% --------------------
% mn = computemean(vr)
% --------------------
% Description: recomputes the mean value of the variable on the given
%              samples.
% Input:       {vr} instance of the variable class.
% Output:      {mn} sample mean.

% © Liran Carmel
% Classification: Update functions
% Last revision date: 24-Jun-2004

mn = mean(nanless(vr));