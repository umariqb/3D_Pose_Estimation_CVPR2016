function vsm = or(vsm,binvector)

% OR restricts (by condition) the samples in a vsmatrix instance.
% ---------------------
% vsm = vsm | binvector
% ---------------------
% Description: the | sign is read, as in mathematics, like "such that". So,
%              {vsm}|{binvector} means a vsmatrix reduced to those samples
%              for which {binvector} is true.
% Input:       {vsm} vsmatrix instance.
%              {binvector} logical vector whose length is the number of
%                   samples of {vsm}.
% Output:      {vsm} reduced vsmatrix.

% © Liran Carmel
% Classification: Operators
% Last revision date: 21-Sep-2004

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(vsm,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(binvector,'binary',{'vector',{'length',nosamples(vsm)}},...
    {mfilename,inputname(2),2}));

% delete samples
vsm = deletesamples(vsm,find(~binvector));