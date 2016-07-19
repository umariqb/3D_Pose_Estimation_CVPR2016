function vsm = subset(vsm,vars,samps)

% SUBSET extracts a subset of the original vsmatrix.
% ------------------------------
% vsm = subset(vsm, vars, samps)
% ------------------------------
% Description: extracts a subset of the original vsmatrix.
% Input:       {vsm} vsmatrix instance.
%              {vars} variables to keep.
%              <{samps}> samples to keep. 'all' or [] stands for all
%                   samples (def).
% Output:      {vsm} updated vsmatrix instance.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 02-Sep-2004

% parse input line
error(nargchk(2,3,nargin));
error(chkvar(vsm,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(vars,'integer',...
    {'vector',{'greaterthan',0},{'eqlower',novariables(vsm)}},...
    {mfilename,inputname(2),2}));
if nargin == 2
    samps = [];
end
if isempty(samps) || isa(samps,'char')
    samps = 1:nosamples(vsm);
else
    error(chkvar(samps,'integer',...
        {'vector',{'greaterthan',0},{'eqlower',nosamples(vsm)}},...
        {mfilename,inputname(3),3}));
end

% remove unnecessary variables
vsm = set(vsm,'variables',vsm.variables(vars));

% remove unnecessary samples
vsm = deletesamples(vsm,allbut(samps,nosamples(vsm)));