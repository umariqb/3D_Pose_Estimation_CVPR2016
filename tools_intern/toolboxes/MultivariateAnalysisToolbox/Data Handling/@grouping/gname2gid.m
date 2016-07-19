function gid = gname2gid(gr,gnames,h_level)

% GNAME2GID finds the GID of a group by its name.
% -----------------------------------
% gid = gname2gid(gr, gnames, h_level)
% -----------------------------------
% Description: finds the GID of a group by its name.
% Input:       {gr} grouping instance.
%              {gnames} cell array of names, or character matrix of names.
%              <{h_level}> hierarchy level (def=1).
% Output:      {gid} the GID of the group. If the group doesn't exist, it
%                   returns NaN.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 06-Sep-2005

% find GCNs
if nargin == 2
    h_level = 1;
end
gcn = gname2gcn(gr,gnames,h_level);

% turn GCNs into GIDs
nonzeros = find(gcn~=0);
gcn2gid = gr.gcn2gid{h_level};
gid = zeros(size(gcn));
gid(nonzeros) = gcn2gid(gcn(nonzeros));