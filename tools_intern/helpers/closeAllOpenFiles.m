function nrClosed = closeAllOpenFiles
%
%   nrClosed = closeAllOpenFiles
%
%   usefull when debugging (and stopping) functions that open a lot of files.
% 
nrClosed = 0;

for i=1:255
    try
        fclose(i);
        nrClosed = nrClosed + 1;
    end
end