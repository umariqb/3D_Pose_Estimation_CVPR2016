function [p_val, stat] = testkshist(varargin)

% TESTKSHIST uses KS test to compare a histograms to a standard.
% ------------------------------------------------------------
% [p_val stat] = testkshist(h_obs, h_stan, p_name, p_val, ...)
% ------------------------------------------------------------
% Description: uses the KS test to compare a histograms to a standard.
% Input:       {h_obs} observed histogram.
%              {h_stan} standard histogram, must be defined on the same
%                   bins as {h_obs}.
%              <{p_name, p_val}> pairs to modify the test. Currently
%                   available:
%                   'test' - determines the type of test. Either 'unequal',
%                       which is the two-sided test "h_obs not equal to h_stan",
%                       'larger', which is the one-sided test "h_obs > h_stan",
%                       and 'smaller', which is the one-sided test "h_obs <
%                       h_stan". By default, the test is two-sided.
% Output:      {p_val} P-value.
%              {stat} test statistic.

% © Liran Carmel
% Classification: Hypothesis testing
% Last revision date: 11-Mar-2005

% parse input line
[h_obs h_stan test] = parseInput(varargin{:});

% compute CDFs
cdf_obs = cumsum(h_obs);
cdf_obs = cdf_obs / cdf_obs(end);
cdf_stan = cumsum(h_stan);
cdf_stan = cdf_stan / cdf_stan(end);

% compute test statistic
switch test
    case 'unequal'
        stat = abs(cdf_obs - cdf_stan);
    case 'larger'
        stat = cdf_obs - cdf_stan;
    case 'smaller'
        stat = cdf_stan - cdf_obs;
end
stat = max(stat);

% compute asymptotic p-value
n = sum(h_obs);
lambda = (sqrt(n) + 0.12 + 0.11/sqrt(n)) * stat;
if strcmp(test,'unequal')   % two-sided test
    j = (1:101)';
    p_val = 2 * sum((-1).^(j-1).*exp(-2*lambda*lambda*j.^2));
    p_val = min(max(p_val,0),1);
else                        % one-sided test
    p_val = exp(-2 * lambda * lambda);
end

% #########################################################################
function [h_obs, h_stan, test] = parseInput(varargin)

% PARSEINPUT parses input line.
% ------------------------------------------
% [h_obs h_stan test] = parseInput(varargin)
% ------------------------------------------
% Description: parses the input line.
% Input:       {varargin} original input line.
% Output:      {h_obs} observed histogram.
%              {h_stan} standard histogram.
%              {test} type of test, either 'unequal', 'larger' or
%                   'smaller'.

% check number of input arguments
error(nargchk(2,Inf,nargin));

% first argument is always {h_obs}
error(chkvar(varargin{1},'integer','vector',{mfilename,'',1}));
h_obs = varargin{1};

% second argument is always {h_stan}
error(chkvar(varargin{2},'double','vector',{mfilename,'',2}));
h_stan = varargin{2};

% check consistency
if length(h_obs) ~= length(h_stan)
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