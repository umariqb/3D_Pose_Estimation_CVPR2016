function word = fitint(ii,len)

% FITINT prints an integer with preceding zeros.
% ----------------------
% word = fitint(ii, len)
% ----------------------
% Description: puts an integer in the right-hand-side of a prespecified
%              space. To the left, the space is filled with zeros. If the
%              number is longer then the allocated width, {word} is larger
%              than {len}.
% Input:       {ii} an integer.
%              {len} prespecified length (violated when {ii} is too big).
% Output:      {word} a string of width {len} with preceding zeros (unless
%                   the integer {ii} is too big to fit into length-{len}
%                   string).
% Examples:    fitint(111,4) gives '0111'.
%              fitint(111,2) gives '111'.

% © Liran Carmel
% Classification: String manipulations
% Last revision date: 02-Jan-2007

% make a string
word = int2str(ii);

% add zeros, if necessary
if length(word) < len
    word = [char(48*ones(1,len-length(word))) word];
end