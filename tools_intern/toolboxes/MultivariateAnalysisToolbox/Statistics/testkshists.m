function [p_val, stat] = testkshists(varargin)

% TESTKSHISTS uses KS test to compare two histograms.
% ------------------------------------------------------
% [p_val stat] = testkshists(h1, h2, p_name, p_val, ...)
% ------------------------------------------------------
% Description: uses the KS test to compare two histograms.
% Input:       {h1} first histogram.
%              {h2} second histogram, must be defined on the same bins as
%                   {h1}.
%              <{p_name, p_val}> pairs to modify the test. Currently
%                   available:
%                   'test' - determines the type of test. Either 'unequal',
%                       which is the two-sided test "h1 not equal to h2",
%                       'larger', which is the one-sided test "h1 > h2",
%                       and 'smaller', which is the one-sided test "h1 <
%                       h2". By default, the test is two-sided.
% Output:      {p_val} P-value.
%              {stat} test statistic.

% © Liran Carmel
% Classification: Hypothesis testing
% Last revision date: 11-Mar-2005

% parse input line
[h1 h2 test] = parseInput(varargin{:});

% compute CDFs
cdf1 = cumsum(h1);
cdf1 = cdf1 / cdf1(end);
cdf2 = cumsum(h2);
cdf2 = cdf2 / cdf2(end);

% compute test statistic
switch test
    case 'unequal'
        stat = abs(cdf1 - cdf2);
    case 'larger'
        stat = cdf1 - cdf2;
    case 'smaller'
        stat = cdf2 - cdf1;
end
stat = max(stat);

% compute asymptotic p-value
n1 = sum(h1);
n2 = sum(h2);
n = n1 * n2 / (n1 + n2);
lambda = (sqrt(n) + 0.12 + 0.11/sqrt(n)) * stat;
if strcmp(test,'unequal')   % two-sided test
    j = (1:101)';
    p_val = 2 * sum((-1).^(j-1).*exp(-2*lambda*lambda*j.^2));
    p_val = min(max(p_val,0),1);
else                        % one-sided test
    p_val = exp(-2 * lambda * lambda);
end

% #########################################################################
function [h1, h2, test] = parseInput(varargin)

% PARSEINPUT parses input line.
% -----------------------------------
% [h1 h2 test] = parseInput(varargin)
% -----------------------------------
% Description: parses the input line.
% Input:       {varargin} original input line.
% Output:      {h1} first histogram.
%              {h2} second histogram.
%              {test} type of test, either 'unequal', 'larger' or
%                   'smaller'.

% check number of input arguments
error(nargchk(2,Inf,nargin));

% first argument is always {h1}
error(chkvar(varargin{1},'integer','vector',{mfilename,'',1}));
h1 = varargin{1};

% second argument is always {h2}
error(chkvar(varargin{2},'integer','vector',{mfilename,'',1}));
h2 = varargin{2};

% check consistency
if length(h1) ~= length(h2)
    error('The two histograms should have the same length');
end

% defaults
test = 'unequal';

% loop on instructions
for ii = 3:2:nargin
    errmsg = {mfilename,'',ii+1};
    switch str2keyword(varargin{ii},4)
        case 'test'   % instruction: test
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            switch str2keyword(varargin{ii+1},4)
                case 'uneq'     % test 'unequal'
                    test = 'unequal';
                case 'larg'     % test 'larger'
                    test = 'larger';
                case 'smal'     % test 'smaller'
                    test = 'smaller';
                otherwise
                    error('%s: unfamiliar test',varargin{ii+1});
            end
        otherwise
            error('%s: unfamiliar instruction',upper(varargin{ii}));
    end
end