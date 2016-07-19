function str_blanked = reblank(str)

% REBLANK removes leading spaces from a string.
% --------------------------
% str_blanked = reblank(str)
% --------------------------
% Description: removes leading spaces from a string.
% Input:       {str} any string.
% Output:      {str_blanked} same as {str} but without any leading spaces.

% © Liran Carmel
% Classification: String manipulations
% Last revision date: 06-Feb-2004

str_blanked = fliplr(deblank(fliplr(str)));