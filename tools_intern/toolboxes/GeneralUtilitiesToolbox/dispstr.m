function dispstr(str)

% DISPSTR displays string array with line numbering.
% ------------
% dispstr(str)
% ------------
% Description: displays string array with line numbering.
% Input:       {str} is a string array.

% © Liran Carmel
% Classification: Display
% Last revision date: 15-Jul-2004

% transform cell array into a string
if isa(str,'cell')
    str = char(str);
end

% display content
for ii = 1:size(str,1)
   disp([int2str(ii) '   ' str(ii,:)]);
end