function [R, P, Rlo, Rup] = pearson(A,B)

% PEARSON computes the Pearson (linear) correlation matrix.
% ----------------------------
% [R P Rlo Rup] = pearson(A,B)
% ----------------------------
% Description: Computes the Pearson (linear) correlation matrix. There are
%              two differences between this function and CORRCOEF. First,
%              the data is variables-by-samples here, in contrast to
%              samples-by-variables in CORRCOEF. Second, corrcoef(A,B) is
%              the same as corrcoef([A B]). This is not the case for
%              PEARSON, where pearson([A ; B]) = corrcoef([A' B']) but
%              pearson(A,B) is just a (potentially rectangular) matrix of
%              the correlation for each pair (a,b) where a is in A and b is
%              in B.
% Input:       {A} any data matrix variables-by-samples.
%              <{B}> any data matrix with the same number of
%                   measurement as in {A}. Basically, the correlation
%                   coefficients are calculated between the variables of
%                   {A} and {B}. If {B} is missing, the correlation
%                   coefficients are calculated between the variables of
%                   {A}.
% Output:      {R} Pearson correlations.
%              {P} P-value of the independence hypothesis testing.
%              {Rlo} lower bound for 95% confidence interval.
%              {Rup} upper bound for 95% confidence interval.

% © Liran Carmel
% Classification: Correlations
% Last revision date: 20-Mar-2006

% low-level input parsing
error(nargchk(1,2,nargin));
single_matrix_correlation = false;
if nargin == 1
    single_matrix_correlation = true;
end

% calculate
if single_matrix_correlation
    [R P Rlo Rup] = corrcoef(A');
elseif isscalar(A)
    R = nan;
    P = 1;
    Rlo = nan;
    Rup = nan;
else
    vars_A = 1:size(A,1);
    vars_B = size(A,1) + (1:size(B,1));
    [R P Rlo Rup] = corrcoef([A' B']);
    R = R(vars_A,vars_B);
    P = P(vars_A,vars_B);
    Rlo = Rlo(vars_A,vars_B);
    Rup = Rup(vars_A,vars_B);
end