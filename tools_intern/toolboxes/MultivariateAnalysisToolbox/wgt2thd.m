function D = wgt2thd(W)

% WGT2THD computes, given weights, a default THD matrix.
% --------------
% D = wgt2thd(W)
% --------------
% Description: computes, given weights, a default THD matrix. assumes that
%              if there is an edge between nodes i and j, then its
%              direction is from i to j if i<j.
% Input:       {W} weights matrix.
% Output:      {D} target height differences matrix.

% © Liran Carmel
% Classification: Friends of graph
% Last revision date: 10-Sep-2004

D = triu(W);    % take only the upper triangle
D = (D ~= 0);   % take one whenever W_{ij} ~= 0
D = D - D';     % complete the lower triangle so that {D} is antisymmetric