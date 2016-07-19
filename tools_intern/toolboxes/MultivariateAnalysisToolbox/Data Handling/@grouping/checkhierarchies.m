function [binflag where] = checkhierarchies(gr)

% CHECKHIERARCHIES checks the consistency of hierarchies.
% ------------------------------
% binflag = checkhierarchies(gr)
% ------------------------------
% Description: checks if the hierarchies within a grouping are consistent
%              with each other. All hierarchies 2,...,{no_hierarchies} are
%              checked with respect to the first hierarchy.
% Input:       {gr} grouping instance(s).
% Output:      {binflag} logical vector of length {no_hierarchies}, with 1
%                   indicating consistent hierarchy (with respect to the
%                   first), and 0 indicating inconsistent hierarchy. If
%                   {gr} is nonscalar, {binflag} is a cell array of the
%                   dimensions of {gr}.
%              {where} hints the user in the location of the inconsistency.
%                   It is a vector of length {no_hierarchies}, with the GID
%                   of the group (in the finer hierarchy) that failed the
%                   consistency check. Zero indicates no failure of the
%                   consistency check.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 13-Dec-2004

% initialize output
binflag = cell(size(gr));
where = cell(size(gr));

% loop on all instances
for ii = 1:numel(gr)
    % initialize
    bf = true(1,gr(ii).no_hierarchies);
    wh = zeros(1,gr(ii).no_hierarchies);
    no_groups = gr(ii).no_groups;
    % loop on hierarchies
    for hh = 2:gr(ii).no_hierarchies
        % retrieve GIDs for hierarchy {hh}
        gids = gr(ii).gcn2gid{hh};
        % loop on the groups of hierachy {hh}
        for gg = 1:no_groups(hh)
            % retrieves samples indices of group {gg} of hierarchy {hh}
            samples = grp2samp(gr(ii),gids(gg),hh);
            % retrieve corresponding samples in the first hierarchy
            h1_samples = gr(ii).assignment(1,samples);
            % check for inconsistency
            if any(h1_samples - h1_samples(1))
                bf(hh) = false;
                wh(hh) = gids(gg);
                break;
            end
        end
    end
    % substitue in output variable
    binflag{ii} = bf;
    where{ii} = wh;
end

% turn cell into double when {gr} is scalar
if isscalar(gr)
    binflag = binflag{1};
    where = where{1};
end