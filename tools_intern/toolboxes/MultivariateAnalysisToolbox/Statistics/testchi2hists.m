function [p_val, stat] = testchi2hists(varargin)

% TESTCHI2HISTS uses the chi2 test to compare two histograms.
% --------------------------------------------------------
% [p_val stat] = testchi2hists(h1, h2, p_name, p_val, ...)
% --------------------------------------------------------
% Description: uses the chi2 test to compare two histograms.
% Input:       {h1} first histogram.
%              {h2} second histogram, must be defined on the same bins as
%                   {h1}.
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
% Last revision date: 11-Mar-2005

% parse input line
[h1 h2 is_equal] = parseInput(varargin{:});

% test identity of distributions
if is_equal
    stat = sum( (h1 - h2).^2 ./ (h1 + h2) );
    dof = length(h1) - 1;
else
    no_samp_1 = sum(h1);
    no_samp_2 = sum(h2);
    stat = sum( ( sqrt(no_samp_1/no_samp_2)*h2 - ...
        sqrt(no_samp_2/no_samp_1)*h1 ).^2 ./ (h1 + h2) );
    dof = length(h1);
end
p_val = 1 - chi2cdf(stat,dof);

% #########################################################################
function [h1, h2, is_equal] = parseInput(varargin)

% PARSEINPUT parses input line.
% ---------------------------------------
% [h1 h2 is_equal] = parseInput(varargin)
% ---------------------------------------
% Description: parses the input line.
% Input:       {varargin} original input line.
% Output:      {h1} first histogram.
%              {h2} second histogram.
%              {is_equal} indicates whether the number of samples in both
%                   histograms are equal or not.

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