function dispchangingcontentupdate(fid,width,num)

% DISPCHANGINGCONTENTUPDATE updates the changing context line.
% ------------------------------------------
% dispchangingcontentupdate(fid, width, num)
% ------------------------------------------
% Description: updates the changing context line, of the form:
%                   HEADER: running_number.
%              The header is set with the accompanying
%              DISPCHANGINGCONTENTHEADER function.
% Input:       {fid} file handle.
%              {width} of changing context part.
%              {num} the {running_number} to display.

% © Liran Carmel
% Classification: Display
% Last revision date: 10-Mar-2008

% make a vector of backword slashes of length {width}
backwards = char(8*ones(1,width));

% print the update
fprintf(fid,'%s%s',backwards,fitint(num,width));