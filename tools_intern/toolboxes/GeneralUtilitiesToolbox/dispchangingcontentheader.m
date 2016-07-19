function width = dispchangingcontentheader(fid,header,max_number)

% DISPCHANGINGCONTENTHEADER sets up a line with changing content.
% ----------------------------------------------------------
% width = dispchangingcontentheader(fid, header, max_number)
% ----------------------------------------------------------
% Description: sets up a line with changing content. The idea is to have a
%              line in the form:
%                   HEADER: running_number
%              with the running_number keeps updating at each iteration
%              with the accompanying function DISPCHANGINGCONTENTUPDATE.
% Input:       {fid} file handle.
%              {header} the part of the line that is not changing.
%              {max_number} maximum value of {running_number}.
% Output:      {width} number of characters required to display
%                   {max_number}.

% © Liran Carmel
% Classification: Display
% Last revision date: 10-Mar-2008

% make a vector of spaces of length {width}
width = num2width(max_number);
spc = char(32*ones(1,width));

% print the header
fprintf(fid,'%s %s',header,spc);