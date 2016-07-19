function gr = subgrouping(gr, h_level)

% SUBGROUPING builds a grouping with a subset of the hierarchies.
% -----------------------------
% gr = subgrouping(gr, h_level)
% -----------------------------
% Description: builds a grouping instance containing a subset of the
%              original hierarchies.
% Input:       {gr} grouping instance.
%              {h_level} list of hierarchies to keep.
% Output:      {gr} grouping instance.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 04-Jul-2004

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(h_level,'integer',...
    {'vector',{'eqlower',gr.no_hierarchies},{'greaterthan',0}},...
    {mfilename,inputname(2),2}));

% modify {gr}
to_remove = allbut(h_level,gr.no_hierarchies);
gr.no_hierarchies = length(h_level);
gr.no_groups(to_remove) = [];
gr.assignment(to_remove,:) = [];
gr.naming(to_remove) = [];
gr.is_consistent(to_remove) = [];
gr.gid2gcn(to_remove) = [];
gr.gcn2gid(to_remove) = [];