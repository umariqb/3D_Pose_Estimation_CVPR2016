function W = thd2wgt(D)

% THD2WGT computes, given THD, a default weight matrix.
% --------------
% W = thd2wgt(D)
% --------------
% Description: computes, given THD, a default weight matrix. assigns a unit
%              weight to each directed edge.
% Input:       {D} target height differences matrix.
% Output:      {W} weights matrix.

% © Liran Carmel
% Classification: Friends of graph
% Last revision date: 10-Sep-2004

W = (D ~= 0);