%LOGICAL_AND_SUM And-sum of elemtens
%   S = LOGICAL_AND_SUM(X, DIM) is the sum of the elements of the vector X.
%   along the dimension DIM. X is a matrix, S is a row vector with the and-sum 
%   over each column. 
%
%   Examples:
%   If   X = [0 0   0 1   1  0.5;
%             0 0.5 1 0.5 1  0.5]
%
%   then logical_and_sum(X,1) is [0 0.5 0.5 0.5 1 0.5] 
%   and sum(X,2) is [ 0.5; 
%                     0.5 ]

function res = logical_and_sum(input, dimension)


res = sum(input, dimension)/size(input, dimension);
res(res ~= 0 & res ~= 1) = 0.5;
