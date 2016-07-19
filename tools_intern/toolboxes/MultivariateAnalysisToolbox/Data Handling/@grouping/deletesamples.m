function gr = deletesamples(gr,to_remove)

% DELETESAMPLES eliminate samples from a grouping instance.
% ---------------------------------
% gr = deletesamples(gr, to_remove)
% ---------------------------------
% Description: eliminate samples from a grouping instance.
% Input:       {gr} group instance(s).
%              {to_remove} samples to delete.
% Output:      {gr} updated group instance(s).

% © Liran Carmel
% Classification: Operations
% Last revision date: 09-Dec-2004

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(gr,{},'vector',{mfilename,inputname(1),1}));

% make a recursion if {gr} is a vector
if length(gr) > 1
    for ii = 1:length(gr)
        gr(ii) = deletesamples(gr(ii),to_remove);
    end
    return;
end

% check second argument
no_samples = nosamples(gr);
error(chkvar(to_remove,'integer',{'vector',{'eqlower',no_samples}},...
    {mfilename,inputname(2),2}));

% magnitudes that are required for determining the new NAMING field.
% {to_remain} lists the sample indices that are not removed, and {gr_con}
% is the transformation of the grouping into a consistent object
to_remain = allbut(to_remove,no_samples);
gr_con = consistent(gr);

% update assignment
gr.assignment(:,to_remove) = [];

% update no_samples
gr.no_samples = length(to_remain);

% loop on all hierarchies
for ii = 1:gr.no_hierarchies
    % check whether the deletion completely removes groups
    gr_tmp = grouping(gr_con.assignment(ii,to_remain),[]);
    % remove names of groups that no longer exists
    names = gr.naming{ii};
    names((max(gr_tmp.assignment)+1):gr_con.no_groups(ii)) = [];
    names(find(isnan(gr_tmp.gid2gcn{1}))) = [];
    gr.naming{ii} = cellstr(names);
    [gr.no_groups(ii) gr.is_consistent(ii) gr.gid2gcn(ii)] = ...
        processassignment(gr.assignment(ii,:));
    gr.gcn2gid{ii} = find(~isnan(gr.gid2gcn{ii}));
end