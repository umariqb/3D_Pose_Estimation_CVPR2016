function [no_groups, is_consistent, gid2gcn] = processassignment(assignment)

% PROCESSASSIGNMENT computes grouping read-only variables.
% -----------------------------------------------------------------
% [no_groups is_consistent gid2gcn] = processassignment(assignment)
% -----------------------------------------------------------------
% Description: computes grouping read-only variables ({no_groups},
%              {is_consistent}, and {gid2gcn}) for each grouping
%              vector.
% Input:       {assignment} assignment matrix.
% Output:      {no_groups} number of groups in each hierarchy.
%              {is_consistent} indicates whether each hierarchy is
%                   consistent (1), or not (0).
%              {gid2gcn} GID2GCN conversion vector (one vector for each
%                   hierarchy). For a specific hierarchy gid2gcn(ii)=jj
%                   means that GID ii has a GCN of jj. If {assig1} is the
%                   assignment vecotr, {assig2} is the same vector where
%                   the GIDs were replaced by GCNs (the consistent version
%                   of {assign1}), and {gid2gcn} is the transformation,
%                   then they are related via:
%                       gcn2gid = find(~isnan(gid2gcn));
%                       gid2gcn(assig1) = assig2
%                       gcn2gid(assig2) = assig1

% © Liran Carmel
% Classification: Constructors
% Last revision date: 01-Oct-2004

% initialize
no_hierarchies = size(assignment,1);
no_groups = zeros(1,no_hierarchies);
is_consistent = zeros(1,no_hierarchies);
gid2gcn = cell(1,no_hierarchies);

% loop on all hierarchies
for hh = 1:no_hierarchies
    % prepare sorted list of GIDs
    assg = assignment(hh,:);
    GIDs = unique(assg(~isnan(assg)));
    % {no_groups} is the number of different GIDs
    no_groups(hh) = length(GIDs);
    % determine {gid2gcn}
    gid2gcn{hh} = nan(1,GIDs(end));
    gid2gcn{hh}(GIDs) = 1:no_groups(hh);
    % determine {is_consistent}
    if GIDs(end) == no_groups(hh)
        is_consistent(hh) = true;
    else
        is_consistent(hh) = false;
    end
end


