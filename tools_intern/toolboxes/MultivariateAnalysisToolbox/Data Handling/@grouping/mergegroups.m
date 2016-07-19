function gr = mergegroups(varargin)

% MERGEGROUPS merges two or more groups in a grouping.
% -----------------------------------------------------------------
% gr = mergegroups(gr, h_to_merge, gid_to_merge, new_gid, new_name)
% -----------------------------------------------------------------
% Description: merges two or more groups in a grouping. Unless otherwise
%              specified, the new group is assigned with the group number
%              and naming of the smallest group number merged.
% Input:       {gr} grouping instance.
%              {h_to_merge} hierarchy in which groups are merged.
%              {gid_to_merge} GIDs of groups to merge (at least two).
%              <{new_gid}> new GID (def=smallest merged).
%              <{new_name}> new group name (def=name of smallest merged).
% Output:      {gr} modified grouping instance.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 10-Jun-2005

% parse input line
[gr h_level gid_to_merge new_gid new_name] = parse_input(varargin{:});
gcn_to_merge = gr.gid2gcn{h_level}(gid_to_merge);

% samples to merge
samples = grp2samp(gr,gid_to_merge,h_level);

% modify grouping instance - assignment
gr.assignment(h_level,samples) = new_gid;

% modify grouping instance - read-only fields
[gr.no_groups(h_level) gr.is_consistent(h_level) gr.gid2gcn(h_level)] = ...
    processassignment(gr.assignment(h_level,:));
gr.gcn2gid{h_level} = find(~isnan(gr.gid2gcn{h_level}));

% modify grouping instance - naming
naming = gr.naming{h_level};
naming(gcn_to_merge) = [];
new_loc = find(gr.gcn2gid{h_level} == new_gid);
naming = [naming(1:new_loc-1) {new_name} naming(new_loc:end)];
gr.naming{h_level} = naming;

% #########################################################################
function [gr, h_level, gid_to_merge, new_gid, new_name] = parse_input(varargin)

% PARSE_INPUT parses input line.
% ------------------------------------------------------------------
% [gr h_level gid_to_merge new_gid new_name] = parse_input(varargin)
% ------------------------------------------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {gr} grouping instance.
%              {h_level} hierarchy level.
%              {gid_to_merge} number of groups to merge.
%              {new_gid} new GID.
%              {new_name} new group name.

% verify number of arguments
error(nargchk(3,5,nargin));

% first argument is always {gr}
error(chkvar(varargin{1},{},'scalar',{mfilename,'',1}));
gr = varargin{1};

% second argument is always {h_level}
error(chkvar(varargin{2},'integer',{'scalar',{'eqlower',nohierarchies(gr)}},...
    {mfilename,'',2}));
h_level = varargin{2};

% third argument is always {gid_to_merge}
error(chkvar(varargin{3},'integer',...
    {'vector',{'minlength',2},{'maxlength',nogroups(gr,h_level)}},...
    {mfilename,'',3}));
gid_to_merge = varargin{3};

% defaults
gid2gcn = gr.gid2gcn{h_level};
new_gid = min(gid_to_merge);
new_name = gr.naming{h_level}{gid2gcn(new_gid)};

% next arguments
for ii = 4:nargin
    [msg1 is_int] = chkvar(varargin{ii},'integer',{},{mfilename,'',ii});
    if is_int
        error(chkvar(varargin{ii},{},'scalar',{mfilename,'',ii}));
        new_gid = varargin{ii};
        % verify that {new_num} is not already in use
        if any(new_gid == gr.gcn2gid{h_level}) && ~any(new_gid == gid_to_merge)
            error('New GID is already in use');
        end
    else
        [msg2 is_char] = chkvar(varargin{ii},'char',{},{mfilename,'',ii});
        if is_char
            new_name = varargin{ii};
        else
            error('%s\n%s',msg1,msg2);
        end
    end
end