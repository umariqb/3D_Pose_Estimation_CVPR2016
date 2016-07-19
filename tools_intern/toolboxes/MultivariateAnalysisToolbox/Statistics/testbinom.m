function pval = testbinom(x,n,p0,test)

% TESTBINOM computes the p-value of testing a binomial parameter.
% --------------------------------
% pval = testbinom(x, n, p0, test)
% --------------------------------
% Description: computes the p-value of testing the hypothesis the that
%              probability of binomial success is {p0}, against one-sided
%              or two-sided alternatives. The test performed is the exact
%              binomial test (thus very conservative). The two-sided test
%              uses the well-accepted convention that
%                   P(two-sided) = 2*min(P(left),P(right)).
% Input:       {x} observed number of successes.
%              {n} number of experiments.
%              {p0} tested probability.
%              <{test}> can be
%                   'p>p0' -  the alternative is p>p0 (default).
%                   'p<p0' -  the alternative is p>p0.
%                   'p~=p0' - the alternative is p~=p0.
% Output:      {pval} p-value.

% © Liran Carmel
% Classification: Hypothesis testing
% Last revision date: 03-Jan-2007

% check number of argumesnts
error(nargchk(3,4,nargin));
if nargin < 4
    test = 'p>p0';
end
error(chkvar(x,'integer','scalar',{mfilename,inputname(1),1}));
error(chkvar(n,'integer',{'scalar',{'eqgreater',x}},...
    {mfilename,inputname(2),2}));
error(chkvar(p0,'double',{'scalar',{'eqgreater',0},{'eqlower',1}},...
    {mfilename,inputname(3),3}));
error(chkvar(test,'char','vector',{mfilename,'test',4}));

% compute the p_value
switch str2keyword(test,2)
    case 'p>'
        if x
            pval = 1 - binocdf(x-1,n,p0);
        else
            pval = 1;
        end
    case 'p<'
        pval = binocdf(x,n,p0);
    case 'p~'
        pval = 2*min(testbinom(x,n,p0,'p>p0'),testbinom(x,n,p0,'p<p0'));
    otherwise
        error('%s: Unrecognized test',test);
end