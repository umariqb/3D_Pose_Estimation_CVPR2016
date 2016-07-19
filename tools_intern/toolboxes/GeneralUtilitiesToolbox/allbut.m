function out = allbut(idx,total)

% ALLBUT produces a vector of successive integers, missing specific ones.
% -----------------------
% out = allbut(idx,total)
% -----------------------
% Description: generates a vector of successive integers, missing but one integer.
% Input:       {idx} list of missing values.
%              {total} last index of the vector.
% Output:      {out} is the vector [1,2,...,total] missing the values
%                   idx(1),idx(2),...,idx(end).

% © Liran Carmel
% Classification: Vector manipulations
% Last revision date: 16-Jan-2004

out = 1:total;
out(idx) = [];