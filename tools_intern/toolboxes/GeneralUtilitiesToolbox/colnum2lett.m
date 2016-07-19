function lett = colnum2lett(num)

% COLNUM2LETT finds the letter combination that fits a certain number.
% -----------------------
% num = collett2num(lett)
% -----------------------
% Description: finds the letter combination in Excel format that fits a
%              certain number.
% Input:       {num} column number.
% Output:      {lett} corresponding letter combination in Excel format.

% © Liran Carmel
% Classification: Excel manipulations
% Last revision date: 11-Mar-2008

% if within the first A-Z columns
if num < 27
    lett = char(num + 64);
    return;
end

% if a two letter column
first = floor((num-1)/26);
if first < 27
    % two letter combination
    lett = char(first + 64);
else
    error('Cannot handle more than two letter columns');
end
second = num - 26*first;
lett = [lett char(second + 64)];