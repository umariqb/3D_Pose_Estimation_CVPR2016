function p_val = testsphericity(pc,factors)

% TESTSPHERICITY tests the sphericity hypothesis.
% -----------------------------------
% p_val = testsphericity(pc, factors)
% -----------------------------------
% Description: tests the sphericity hypothesis, see eq. (3.33) in Flury.
% Input:       {pc} PCATRANS instance.
%              {factors} factors that are candidate of being spherical.
% Output:      {p_val} p-value of the test.

% © Liran Carmel
% Classification: Inference
% Last revision date: 18-Jan-2005

% parse input
error(nargchk(2,2,nargin));
error(chkvar(pc,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(factors,'integer',{'vector',{'minlength',2},...
    {'greaterthan',0},{'eqlower',nofactors(pc)}},...
    {mfilename,inputname(2),2}));

% retrive eigenvalues
e_vals = eigvals(pc,factors);

% build the statistic
r = length(factors);
stat = nosamples(pc) * r * log(mean(e_vals) / geomean(e_vals));

% find p_value
p_val = 1 - chi2cdf(stat,r*(r+1)/2-1);

