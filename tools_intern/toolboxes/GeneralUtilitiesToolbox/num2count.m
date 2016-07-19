function str = num2count(num)

% NUM2COUNT gives counting text coressponding to a number.
% --------------------
% str = num2count(num)
% --------------------
% Description: gives counting text coressponding to a number, e.g., it
%              gives the string '1st' to the number 1, and the string '5th'
%              to the number 5.
% Input:       {num} an integer.
% Output:      {str} corresponding counting string.

% © Liran Carmel
% Classification: String manipulations
% Last revision date: 28-Apr-2006

% get the last digit
reminder = rem(num,10);

% initialize string
str = num2str(num);

% use special terminology for 1,2,3
switch reminder
    case 1
        str = [str 'st'];
    case 2
        str = [str 'nd'];
    case 3
        str = [str 'rd'];
    otherwise
        str = [str 'th'];
end