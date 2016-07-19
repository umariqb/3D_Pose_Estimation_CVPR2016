function gcn = gname2gcn(gr,gnames,h_level)

% GNAME2GCN finds the GCN of a group by its name.
% -----------------------------------
% gcn = gname2gcn(gr, gnames, h_level)
% -----------------------------------
% Description: finds the GCN of a group by its name.
% Input:       {gr} grouping instance.
%              {gnames} cell array of names, or character matrix of names.
%              <{h_level}> hierarchy level (def=1).
% Output:      {gcn} the GCN of the group. If the group doesn't exist, it
%                   returns NaN.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 07-Jan-2005

% parse input line
error(nargchk(2,3,nargin));
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));
gnames = char(gnames);
if nargin == 2
    h_level = 1;
else
    error(chkvar(h_level,'integer',{'scalar',{'eqlower',gr.no_hierarchies}},...
        {mfilename,inputname(3),3}));
end

% initialize
no_grps = size(gnames,1);
gcn = zeros(1,no_grps);

% loop on group names
list_grps = gr.naming{h_level};
for ii = 1:no_grps
    str = deblank(gnames(ii,:));
    ind = find(strcmpi(str,list_grps),1);
    if isempty(ind)
        ind = NaN;
    else
        gcn(ii) = ind;
    end
end