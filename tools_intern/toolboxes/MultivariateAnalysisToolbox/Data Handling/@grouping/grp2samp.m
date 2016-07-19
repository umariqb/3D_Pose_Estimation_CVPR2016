function samp = grp2samp(gr,gid,h_level)

% GRP2SAMP extract sample numbers of specific groups.
% ---------------------------------
% samp = grp2samp(gr, gid, h_level)
% ---------------------------------
% Description: extract sample numbers of specific groups.
% Input:       {gr} grouping instance.
%              {gid} GIDs.
%              <{h_level}> hierarchy level (def=1).
% Output:      {samp} the output.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 15-Jun-2004

% parse input line
error(nargchk(2,3,nargin));
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(gid,'integer','vector',{mfilename,inputname(2),2}));
if nargin == 2
    h_level = 1;
else
    error(chkvar(h_level,'integer',{'scalar',{'eqlower',gr.no_hierarchies}},...
        {mfilename,inputname(3),3}));
end

% find samples
samp = [];
for ii = 1:length(gid)
    samp = [samp find(gr.assignment(h_level,:) == gid(ii))];
end

% arrange by order
samp = sort(samp);