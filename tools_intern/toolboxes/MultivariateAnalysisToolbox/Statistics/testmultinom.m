function [pval, expected] = testmultinom(observed,probs,test)

% TESTMULTINOM computes the p-value of testing multinomial parameters.
% -----------------------------------------------------
% [pval expected] = testmultinom(observed, probs, test)
% -----------------------------------------------------
% Description: computes the p-value of testing the hypothesis the that
%              probability vector of a multinomial distribution is {probs}
%              against the alternative hypothesis that it is not.
% Input:       {observed} observed histogram.
%              {probs} tested vector of probabilities.
%              <{test}> can be
%                   'LR'      - likelihood ratio test (default).
%                   'Pearson' - sum-of-square-ratios test.
%                   Pearson's method is an approximation of 'LR', but it is
%                   faster to compute the test statistic. So, on small
%                   data, use 'LR'. If it performs too slow, switch to
%                   'Pearson'. Roughly, 'Pearson' is O.K. as long as
%                   all(expected) >= 5.
% Output:      {pval} p-value.
%              {expected} expected histogram (non-integer entries).

% © Liran Carmel
% Classification: Hypothesis testing
% Last revision date: 01-Feb-2005

% check number of argumesnts
error(nargchk(2,3,nargin));
if nargin < 3
    test = 'lr';
end
error(chkvar(observed,'integer','vector',{mfilename,inputname(1),1}));
no_bins = length(observed);
error(chkvar(probs,'double',...
    {'vector',{'length',no_bins},{'sumto',1}},...
    {mfilename,inputname(2),2}));
error(chkvar(test,'char','vector',{mfilename,'test',3}));

% compute the expected histogram
no_samples = sum(observed);
expected = probs*no_samples;

% compute the test statistic {t_stat}
switch str2keyword(test,2)
    case 'lr'
        t_stat = sum(observed .* log(observed./(expected+eps)));
    case 'pe'
        t_stat = sum((observed - expected).^2 ./ (expected+eps));
    otherwise
        error('%s: Unrecognized test',test);
end

% find p-value
pval = 1 - chi2cdf(t_stat,no_bins-1);