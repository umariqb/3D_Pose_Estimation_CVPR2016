function [tok, rem_str] = strtokn(str, n, delim)

% STRTOKN finds the n'th token in a string
% --------------------------------------
% [tok rem_str] = strtokn(str, n, delim)
% --------------------------------------
% Description: finds the n'th token in a string.
% Input:       {str} the input string.
%              {n} the desired token number.
%              <{delim}> the desired deliminator (def=white space).
% Output:      {tok} the {n}'th token.
%              {rem_str} the remaining string.

% © Liran Carmel
% Classification: String manipulations
% Last revision date: 03-Jun-2004

% Loop {n} times
rem_str = str;
if nargin == 2
   for ii = 1:n
      [tok rem_str] = strtok(rem_str);
   end
else
   for ii = 1:n
      [tok rem_str] = strtok(rem_str,delim);
   end
end
