function no_levels = nohierarchies(gr)

% NOHIERARCHIES returns the number of hierarchies in a GROUPING instance
% -----------------------------
% no_levels = nohierarchies(gr)
% -----------------------------
% Description: returns the degree of hierarchy in a GROUPING instance.
% Input:       {gr} a group instance.
% Output:      {no_levels} degree of hierarchy.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 14-Jun-2004

no_levels = gr.no_hierarchies;