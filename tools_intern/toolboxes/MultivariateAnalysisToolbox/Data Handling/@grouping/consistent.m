function gr = consistent(gr)

% CONSISTENT turns inconsistent assignments into consistent ones.
% -------------------
% gr = consistent(gr)
% -------------------
% Description: turns inconsistent assignments into consistent ones.
% Input:       {gr} group instance.
% Output:      {gr} consistent group instance.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 04-Jul-2004

% loop on all hierarchies
for ii = 1:gr.no_hierarchies
    % transform group vector to be consistent
    gid2gcn = gr.gid2gcn{ii};
    idx = find(~isnan(gr.assignment(ii,:)));
    gr.assignment(ii,idx) = gid2gcn(gr.assignment(ii,idx));
    gr.is_consistent(ii) = true;
    gr.gid2gcn{ii} = 1:gr.no_groups(ii);
    gr.gcn2gid{ii} = gr.gid2gcn{ii};
end