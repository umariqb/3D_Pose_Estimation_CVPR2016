function gr = substitute(gr,h_level,old_gid,new_gid)

% SUBSTITUTE substitutes a subset of GIDs by another subset.
% ----------------------------------------------
% gr = substitute(gr, h_level, old_gid, new_gid)
% ----------------------------------------------
% Description: substitutes a subset of GIDs by another subset.
% Input:       {gr} grouping instance.
%              <{h_level}> hierarchy level (def=1).
%              {old_gid} which GIDs should be replaced.
%              {new_gid} new GIDs.
% Output:      {gr} updated grouping.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 07-Dec-2004

% parse input
error(nargchk(3,4,nargin));
if nargin == 3
    new_gid = old_gid;
    old_gid = h_level;
    h_level = 1;
end
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));
if length(old_gid) ~= length(new_gid)
    error('There should be an equal number of old and new GIDs');
end

% compute new ASSIGNMENT
assignment = substitute(gr.assignment(h_level,:),old_gid,new_gid);

% update fields IS_CONSISTENT and GID2GCN
[no_groups is_consistent gid2gcn] = processassignment(assignment);
if no_groups ~= gr.no_groups(h_level)
    str = sprintf('one or more of the new GIDs appears already as a GID');
    str = sprintf('%s outside the old GIDs subset, ensuing a',str);
    str = sprintf('%s change in the number of groups',str);
    error(str);
end

% substitute ASSIGNMENT, IS_CONSISTENT, and GID2GCN
gr.assignment(h_level,:) = assignment;
gr.is_consistent(h_level) = is_consistent;
gr.gid2gcn(h_level) = gid2gcn;

% update fields GCN2GID, and NAMING
[gr.gcn2gid{h_level} idx] = sort(substitute(gr.gcn2gid{h_level},old_gid,new_gid));
gr.naming{h_level} = gr.naming{h_level}(idx);