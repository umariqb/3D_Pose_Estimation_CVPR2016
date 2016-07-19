function num = collett2num(lett)

% COLLETT2NUM finds the column number that fits a certain string.
% -----------------------
% num = collett2num(lett)
% -----------------------
% Description: finds the column number that fits a certain string in Excel
%              format.
% Input:       {lett} string in Excel column format.
% Output:      {num} corresponding number.

% © Liran Carmel
% Classification: Excel manipulations
% Last revision date: 02-Aug-2006

% make upper
lett = upper(lett);

% if within the first A-Z columns
if length(lett) == 1
    num = double(lett) - 64;
    return;
end

% if a two letter column
if length(lett) == 2
    first = double(lett(1)) - 64;
    second = double(lett(2)) - 64;
    num = 26*first + second;
    return;
end

% cannot handle more than two letter columns
error('Cannot handle more than two letter columns');