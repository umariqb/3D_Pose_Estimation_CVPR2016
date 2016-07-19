function gr_test = testgrouping(gr_train,gr_test)

% TESTGROUPING makes redundant groups in a test set unknowns.
% -----------------------------------------
% gr_test = testgrouping(gr_train, gr_test)
% -----------------------------------------
% Description: turn each group in {gr_test} which does not appear in
%              {tr_train} to unknown. It is assumed that in all other
%              repects the two groupings match.
% Input:       {gr_train} train grouping.
%              {gr_test} test grouping.
% Output:      {gr_test} updated test grouping.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 29-Nov-2005

% recurse if {gr_train} and {gr_test} are vectors
if length(gr_train) > 1
    for ii = 1:length(gr_train)
        gr_test(ii) = testgrouping(gr_train(ii),gr_test(ii));
    end
    return;
end

% loop on all hierarchies
naming_train = gr_train.naming;
naming_test = gr_test.naming;
for hh = 1:gr_test.no_hierarchies
    % locate these groups in {gr_test} which do not appear in {gr_train}
    grp_to_transform = [];
    for ii = 1:gr_test.no_groups(hh)
        if ~any(strcmp(naming_test{hh}{ii},naming_train{hh}))
            grp_to_transform = [grp_to_transform ii];
        end
    end
    % delete these groups from {naming}
    naming_test{hh}(grp_to_transform) = [];
    % turn these group indices to NaNs
    gcn2gid = gr_test.gcn2gid{hh};
    grp_to_transform = gcn2gid(grp_to_transform);
    samp = grp2samp(gr_test,grp_to_transform,hh);
    gr_test.assignment(hh,samp) = NaN;
    [gr_test.no_groups(hh) gr_test.is_consistent(hh) gr_test.gid2gcn{hh}] = ...
        processassignment(gr_test.assignment(hh,:));
end

% update naming
gr_test.naming = naming_test;