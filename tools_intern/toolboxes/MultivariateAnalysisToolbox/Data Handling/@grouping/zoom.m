function gr = zoom(gr,h_level,z_gids)

% ZOOM keeps only a portion of the groupings, merging all the others.
% ------------------------------
% gr = zoom(gr, h_level, z_gids)
% ------------------------------
% Description: keeps only groups of interest, while merging all the others
%              under one group named 'all others'.
% Input:       {gr} a GROUP instance.
%              <{h_level}> hierarchy level.
%              {z_gids} GIDs of zoomed groups.
% Output:      {gr} update GROUP instance.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 13-Jun-2004

% determine {h_level}
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));
if nargin == 2
    z_gids = h_level;
    h_level = 1;
else
    error(chkvar(h_level,'integer',...
        {{'greaterthan',0},{'eqlower',gr.no_hierarchies}},...
        {mfilename,inputname(2),2}));
end
error(chkvar(z_gids,'integer','',{mfilename,inputname(nargin),nargin}));

% get "others" GIDs
o_gids = setdiff(gr.gcn2gid{h_level},z_gids);
no_groups = nogroups(gr,h_level);

% merge all the others
gr = mergegroups(gr,h_level,o_gids,o_gids(1),'all others');