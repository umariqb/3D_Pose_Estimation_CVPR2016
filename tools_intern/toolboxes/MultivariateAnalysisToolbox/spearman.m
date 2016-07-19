function R = spearman(A,B)

% SPEARMAN computes the Spearman rank correlation matrix.
% -----------------
% R = spearman(A,B)
% -----------------
% Description: Computes the Spearman rank correlation matrix.
% Input:       {A} any data matrix variables-by-samples.
%              <{B}> any data matrix with the same number of
%                   measurement as in {A}. Basically, the rank correlation
%                   coefficients are calculated between the variables of
%                   {A} and {B}. If {B} is missing, the correlation
%                   coefficients are calculated between the variables of
%                   {A}.
% Output:      {R} Spearman rank correlations.

% © Liran Carmel
% Classification: Correlations
% Last revision date: 20-Mar-2006

% This function can be tested using the dataset:
%  A = [5 9  17 1 2 21 3 29 7 100]  (hours studied for exam)
%  B = [6 16 18 1 3 21 7 20 15 22]  (number of corrected answers)
% The correlation coefficient should be 0.9758

% low-level input parsing
error(nargchk(1,2,nargin));
single_matrix_correlation = false;
if nargin == 1
    single_matrix_correlation = true;
end

% check the special case that {A} is scalar
if isscalar(A)
    R = nan;
    return;
end

% calculate squared Euclidean distance between ranked samples
A = lineup(A,2);
if single_matrix_correlation
    R = pearson(A);
else
    B = lineup(B,2);
    R = pearson(A,B);
end