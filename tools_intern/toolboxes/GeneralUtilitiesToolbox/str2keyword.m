function str_out = str2keyword(str_in,len)

% STR2KEYWORD extracts unique identifier of reserved keywords.
% ----------------------------------
% str_out = str2keyword(str_in, len)
% ----------------------------------
% Description: finds the initial string that identifies keywords.
% Input:       {str_in} input string.
%              {len} the length of the initial string.
% Output:      {str_out} the initial {len} characters of {str_in} in lower
%                 case, with trailing spaces if {str_in} is too short.

% © Liran Carmel
% Classification: String manipulations
% Last revision date: 06-Jul-2004

% make lower-case
str_out = lower(str_in);

% add trailing spaces if necessary
for ii = length(str_out)+1:len
    str_out = [str_out ' '];
end

% shorten to length {len}
str_out = str_out(1:len);