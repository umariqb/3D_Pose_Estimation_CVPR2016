function [row, col] = cellparts(cl)

% RANGEPARTS breaks an excell cell name into its row and column parts.
% -------------------------
% [row col] = cellparts(cl)
% -------------------------
% Description: breaks an excell cell name into its row and column parts.
% Input:       {cell} cell name in Excel notations.
% Output:      {row} string indicating the row number.
%              {col} string indicating the col letter.

% © Liran Carmel
% Classification: Excel manipulations
% Last revision date: 02-Aug-2006

% make upper case
cl = upper(cl);

% find where the col ends and the row begins
idx = find(cl<65,1);

% output
col = cl(1:(idx-1));
row = cl(idx:end);