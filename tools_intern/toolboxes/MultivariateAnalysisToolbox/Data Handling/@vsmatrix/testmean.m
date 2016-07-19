function p_val = testmean(varargin)

% TESTMEAN tests mean value or mean difference.
% ------------------------------------------------------
% p_val = testmean(vsm1, vsm2, inst_name, inst_val, ...)
% ------------------------------------------------------
% Description: tests if the mean of {vsm} is statistically different from a
%              prespecified mean vector, or if the means of {vsm1} and
%              {vsm2} are significantly different. In one dimension, this
%              is just the t-test.
% Input:       {vsm1} VSMATRIX instance.
%              <{vsm2}> a second VSMATRIX, if a comparison between two
%                   population is required. In this case, TESTMEAN checks
%                   if the mean of {vsm1}-{vsm2} is statistically different
%                   from the zero-vector.
%              <{inst_name, inst_val}> instruction pairs to control the
%                   test. Currently available:
%                   'mu' - assumed mean vector. This is a mandatory input
%                       when {vsm2} is not given.
%                   'test' - can be either 'normal' (def) to indicate that
%                       the samples are assumed to be drawn from a normal
%                       distribution, and then the F-distribution is used,
%                       or it can be 'asymptotic' to indicate that there
%                       are many samples, so that the law of large numbers
%                       can be used, namely the chi2-distribution replaces
%                       the F-distribution.
%                   'dimensions' - indicates a subset of dimensions to be
%                       used in the test. By default, all dimensions are
%                       taken.
%                   'samples' - indicates a subset of samples to be used in
%                       the test. By default, all samples are taken.
% Output:      {p_val} p-value of the test.

% © Liran Carmel
% Classification: Inference
% Last revision date: 24-Feb-2005

% parse input line
[data mu0 test] = parseInput(varargin{:});

% compute test statistic
[no_dims no_samples] = size(data);
smean = mean(data,2);
scov = cov(data');
stat = no_samples * (smean - mu0).' * pinv(scov) * (smean - mu0);

% apply the test
switch test
    case 'normal'
        stat = (no_samples - no_dims) * stat / no_dims / (no_samples-1);
        p_val = 1 - fcdf(stat,no_dims,no_samples-no_dims);
    case 'asymptotic'
        p_val = 1 - chi2cdf(stat,no_dims);
end

% #########################################################################
function [data, mu0, test] = parseInput(varargin)

% PARSEINPUT parses input line.
% --------------------------------------
% [data mu0 test] = parseInput(varargin)
% --------------------------------------
% Description: parses the input line.
% Input:       {varargin} original input line.
% Output:      {data} data matrix (variables-by-samples).
%              {mu0} prespecified mean value.
%              {test} type of test to use.

% check number of input arguments
error(nargchk(1,Inf,nargin));

% first argument is always {vsm1}
error(chkvar(varargin{1},{},'scalar',{mfilename,'',1}));
vsm = varargin{1};

% determine whether one population is compared to reference, or two
% populations are compared.
are_two_populations = false;
idx_instructions = 2;
if isa(varargin{2},'vsmatrix')
    are_two_populations = true;
    idx_instructions = 3;
    vsm = vsm - varargin{2};
end

% defaults
mu0 = [];
test = 'normal';
dims = 1:novariables(vsm);
samps = 1:nosamples(vsm);

% loop on instructions
for ii = idx_instructions:2:nargin
    errmsg = {mfilename,'',ii+1};
    switch str2keyword(varargin{ii},4)
        case 'mu  '     % instruction: mu
            if are_two_populations
                str = '''mu'': illegal instruction when comparing';
                str = sprintf('%s two populations',str);
                error(str);
            else
                error(chkvar(varargin{ii+1},'numerical','vector',errmsg));
                mu0 = varargin{ii+1}(:);
            end
        case 'test'     % instruction: test
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            switch str2keyword(varargin{ii+1},4)
                case 'norm'
                    test = 'normal';
                case 'asym'
                    test = 'asymptotic';
                otherwise
                    error('%s: unfamiliar test',varargin{ii+1});
            end
        case 'dime'     % instruction: dimensions
            error(chkvar(varargin{ii+1},'integer',...
                {'vector',{'greaterthan',0},{'eqlower',novariables(vsm)}},...
                errmsg));
            dims = varargin{ii+1};
        case 'samp'     % instruction: samples
            error(chkvar(varargin{ii+1},'integer',...
                {'vector',{'greaterthan',0},{'eqlower',nosamples(vsm)}},...
                errmsg));
            samps = varargin{ii+1};
        otherwise
            error('%s: unfamiliar instruction',upper(varargin{ii}));
    end
end

% check consistency
if are_two_populations
    mu0 = zeros(length(dims),1);
else
    if isempty(mu0)
        str = '''mu'': mandatory instruction when comparing';
        str = sprintf('%s two populations',str);
        error(str);
    elseif length(mu0) ~= length(dims)
        error('''mu'': its length should equal the number of dimensions');
    end
end

% get {data}
data = vsm.variables(dims,samps);