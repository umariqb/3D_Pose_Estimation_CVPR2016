function [tok rem_str] = strtokl(str, delim)

% STRTOKL finds the last token in a string
% -----------------------------------
% [tok rem_str] = strtokl(str, delim)
% -----------------------------------
% Description: finds the last token in a string.
% Input:       {str} the input string.
%              <{delim}> the desired deliminator (def=white space).
% Output:      {tok} is the last token.
%              {rem_str} the remaining string.

% © Liran Carmel
% Classification: String manipulations
% Last revision date: 03-Feb-2004

% Reverse the string
rem_str = str(end:-1:1);

% Find reversed token
if nargin == 1
   [tok rem_str] = strtok(rem_str);
else
   [tok rem_str] = strtok(rem_str,delim);
end

% Reverse back
tok = tok(end:-1:1);
rem_str = rem_str(end:-1:1);