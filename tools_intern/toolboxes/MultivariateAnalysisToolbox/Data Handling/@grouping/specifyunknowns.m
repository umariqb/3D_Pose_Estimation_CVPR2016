function gr = specifyunknowns(gr)

% SPECIFYUNKNOWNS index the unknown class.
% ------------------------
% gr = specifyunknowns(gr)
% ------------------------
% Description: normally, unknowns are designated by NaN in the grouping
%              assignment vector. If the group indices runs up to
%              {last_idx}, the this function adds an index of vlaue
%              {last_idx}+1, associated with a group name 'unknown'.
% Input:       {gr} original grouping instance.
% Output:      {gr} transformed grouping instance.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 06-Dec-2004

% parse input line
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));

% loop on all hierarchies
for ii = 1:gr.no_hierarchies
    % do something only if Unknowns are present
    if ~isempty(find(isnan(gr.assignment(ii,:)),1))
        nan_idx = nanmax(gr.assignment(ii,:)) + 1;
        gr.assignment(ii,isnan(gr.assignment(ii,:))) = nan_idx;
        gr.no_groups(ii) = gr.no_groups(ii) + 1;
        gr.naming{ii} = [gr.naming{ii} {'unknown'}];
        gr.gid2gcn{ii} = [gr.gid2gcn{ii} gr.no_groups(ii)];
        gr.gcn2gid{ii} = [gr.gcn2gid{ii} nan_idx];
    end
end