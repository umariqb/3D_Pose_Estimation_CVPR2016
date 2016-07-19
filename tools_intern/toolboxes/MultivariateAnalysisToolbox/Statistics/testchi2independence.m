function [pval, e_table] = testchi2independence(c_table)

% TESTCHI2INDEPENDENCE computes the p-value of independence hypothesis.
% ----------------------------------------------
% [pval e_table] = testchi2independence(c_table)
% ----------------------------------------------
% Description: computes the p-value of the hypothesis that outcomes are
%              independent of the conditions (treatments), then the data is
%              organized as a contingency table.
% Input:       {c_table} contingency table.
% Output:      {pval} p-value.
%              {e_table} expected contingency table (under independence).

% © Liran Carmel
% Classification: Hypothesis testing
% Last revision date: 11-Mar-2005

% check number of argumesnts
error(nargchk(1,1,nargin));
error(chkvar(c_table,'integer','matrix',{mfilename,inputname(1),1}));

% compute expected contingency table
[rows cols] = size(c_table);
n = sum2(c_table);
p_col = sum(c_table,1) / n;
p_row = sum(c_table,2) / n;
e_table = n*p_row*p_col;

% chi2 statistic
chi2 = sum2( (c_table - e_table).^2 ./ e_table )

% find p-value
dof = (rows-1) * (cols-1);
pval = 1 - chi2cdf(chi2,dof);