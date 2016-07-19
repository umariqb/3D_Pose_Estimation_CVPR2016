function [p_val, stat] = testchi2hist(varargin)

% TESTCHI2HIST uses the chi2 test to compare a histograms to a standard.
% --------------------------------------------------------------
% [p_val stat] = testchi2hist(h_obs, h_stan, p_name, p_val, ...)
% --------------------------------------------------------------
% Description: uses the chi2 test to compare a histograms to a standard.
% Input:       {h_obs} observed histogram.
%              {h_stan} standard histogram, must be defined on the same
%                   bins as {h_obs}.
%              <{p_name, p_val}> pairs to modify the test. Currently
%                   available:
%                   'noSamples' - if 'equal', then the total number of
%                       samples in both histograms is expected to be
%                       identical. If 'nonequal', then the total number of
%                       samples is considered non-equal among the two
%                       histograms, even if it equals in practice. By
%                       default, the number of samples is assumed equal.
% Output:      {p_val} P-value.
%              {test} test statistic.

% © Liran Carmel
% Classification: Hypothesis testing
% Last revision date: 27-Oct-2005

% parse input line
[h_obs h_stan is_equal] = parseInput(varargin{:});

% remove zeros
zeros = find(~h_stan);
common = find(~h_obs(zeros));
h_obs(zeros(common)) = [];
h_stan(zeros(common)) = [];

% compute test statistics
if length(zeros) == length(common)
    stat = sum( (h_obs - h_stan).^2 ./ h_stan );
else
    stat = nan;
end

% test identity of distributions
if is_equal
    dof = length(h_obs) - 1;
else
    dof = length(h_obs);
end
p_val = 1 - chi2cdf(stat,dof);

% #########################################################################
function [h_obs, h_stan, is_equal] = parseInput(varargin)

% PARSEINPUT parses input line.
% ----------------------------------------------
% [h_obs h_stan is_equal] = parseInput(varargin)
% ----------------------------------------------
% Description: parses the input line.
% Input:       {varargin} original input line.
% Output:      {h_obs} observed histogram.
%              {h_stan} standard histogram.
%              {is_equal} indicates whether the number of samples in both
%                   histograms are equal or not.

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
is_equal = true;

% loop on instructions
for ii = 3:2:nargin
    errmsg = {mfilename,'',ii+1};
    switch str2keyword(varargin{ii},6)
        case 'nosamp'   % instruction: noSamples
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            switch str2keyword(varargin{ii+1},3)
                case 'equ'
                    is_equal = true;
                case 'non'
                    is_equal = false;
                otherwise
                    error('%s: undefined option of ''noSamples''',...
                        varargin{ii+1});
            end
        otherwise
            error('%s: undefined instruction',varargin{ii});
    end
end