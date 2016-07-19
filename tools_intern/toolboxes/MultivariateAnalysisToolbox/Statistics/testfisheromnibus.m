function pval = testfisheromnibus(val)

% TESTFISHEROMNIBUS computes p-value for the Fisher Omnibus test.
% -----------------------------
% pval = testfisheromnibus(val)
% -----------------------------
% Description: computes p-value for the Fisher Omnibus test.
% Input:       {val} list of p-values derived from a series of one-sided
%                   tests.
% Output:      {pval} p-value of Fisher Omnibus.

% © Liran Carmel
% Classification: Hypothesis testing
% Last revision date: 30-Apr-2006

% replace zeros by small numbers
val(val==0) = eps;

% test statistics
stat = -2*sum(log(val));

% p-value
pval = 1 - chi2cdf(stat,2*length(val));