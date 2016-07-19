function naming = defnames(no_groups)

% DEFNAMES generates a default naming for a grouping.
% ------------------------------------
% naming = fill_group_names(no_groups) 
% ------------------------------------
% Description: generates a default naming for a grouping.
% Input:       {no_groups} number of groups.
% Output:      {naming} default names cell-array.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 10-Sep-2004

naming = {};
for grp = 1:no_groups
    naming = [naming {['group #' int2str(grp)]}];
end