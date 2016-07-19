function gr = grp2unknowns(gr,gids,h_level)

% GRP2UNKNOWNS turns known groups into unknowns.
% ------------------------------------
% gr = grp2unknowns(gr, gids, h_level)
% ------------------------------------
% Description: turns known groups into unknowns.
% Input:       {gr} original grouping instance.
%              {gids} GIDs of groups to turn into unknowns.
%              <{h_level}> hierarchy level (def = 1). Matching samples in
%                   higher hierarchies (h > h_level) are changes to
%                   unknowns too, to keep compatibility.
% Output:      {gr} transformed grouping instance.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 09-Feb-2005

% parse input line
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));
if nargin == 2
    h_level = 1;
else
    error(chkvar(h_level,'integer',{'scalar',{'eqlower',gr.no_hierarchies}},...
        {mfilename,inputname(3),3}));
end

% modify assignment and namings
no_hierarchies = gr.no_hierarchies;
gcns_to_remove = cell(1,no_hierarchies - h_level + 1);
assg = gr.assignment(h_level:end,:);
for ii = 1:length(gids)
    samples = grp2samp(gr,gids(ii),h_level);
    for jj = h_level:no_hierarchies
        gid2gcn = gr.gid2gcn{jj};
        gcns_to_remove{jj-h_level+1} = [gcns_to_remove{jj-h_level+1} ...
            gid2gcn(unique(assg(jj,samples)))];
    end
    assg(:,samples) = NaN;
end
[no_groups is_consistent gid2gcn] = processassignment(assg);

% update grouping fields: no_groups, assignment, is_consistent & gid2gcn
gr.no_groups(h_level:end) = no_groups;
gr.assignment(h_level:end,:) = assg;
gr.is_consistent(h_level:end) = is_consistent;
gr.gid2gcn(h_level:end) = gid2gcn;

% update grouping fields: naming & gcn2gid
for jj = h_level:no_hierarchies
    naming = gr.naming{jj};
    naming(gcns_to_remove{jj-h_level+1}) = [];
    gr.naming{jj} = naming;
    gr.gcn2gid{jj} = find(~isnan(gr.gid2gcn{jj}));
end