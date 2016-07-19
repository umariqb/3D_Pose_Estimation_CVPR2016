function idx = sorthierarchies(assignment,no_groups)

% SORTHIERARCHIES sorts hierarchies from the coarsest to the finest.
% --------------------------------------------
% idx = sorthierarchies(assignment, no_groups)
% --------------------------------------------
% Description: sorts hierarchies from the coarsest to the finest, as well
%              as removes redundant hierarchies.
% Input:       {assignment} assignment matrix.
%              {no_groups} number of groups in each hiearchy.
% Output:      {idx} list of sorted indices, meaning that hierarchy(idx,:)
%                   is now a sorted hierarchy matrix with no redundancies.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 02-Sep-2004

% sort hierarchies using the number of groups as a criterion
[nog idx] = sort(no_groups);    %#ok

% remove redundancies
redun = find(~diff(no_groups(idx)));
while ~isempty(redun)
    redun = redun(1);
    if any(assignment(idx(redun),:) - assignment(idx(redun+1),:))
        error('Two non-identical hierarchies found with equal number of groups');
    else
        idx(redun) = [];
    end
    redun = find(~diff(no_groups(idx)));
end