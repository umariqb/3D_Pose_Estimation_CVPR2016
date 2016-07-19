function vari = computevariance(vr)

% COMPUTEVARIANCE calculates sample variance.
% --------------------------
% vari = computevariance(vr)
% --------------------------
% Description: calculates the sample variance of the given samples
%              (normalized by N-1).
% Input:       {vr} instance of the variable class.
% Output:      {vari} sample variance.

% © Liran Carmel
% Classification: Update functions
% Last revision date: 24-Jun-2004

vari = var(nanless(vr));