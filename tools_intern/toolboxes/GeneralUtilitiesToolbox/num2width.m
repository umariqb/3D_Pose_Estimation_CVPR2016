function width = num2width(num)

% NUM2WIDTH width (in characters) required to display {num}.
% ----------------------
% width = num2width(num)
% ----------------------
% Description: width (in characters) required to display {num}.
% Input:       {num} any number (array).
% Output:      {width} number of characters needed to display each of the
%                   numbers in {num} (array, same size as {num}).

% © Liran Carmel
% Classification: String manipulations
% Last revision date: 10-Mar-2008

width = 1 + floor(log10(num));