function [ax, cent, rot] = cimean(varargin)

% CIMEAN finds CI for multidimensional mean.
% -----------------------------------------------------
% [ax cent rot] = cimean(vsm, inst_name, inst_val, ...)
% -----------------------------------------------------
% Description: finds CI for multidimensional mean.
% Input:       {vsm} VSMATRIX instance.
%              <{inst_name, inst_val}> instruction pairs to control the CI.
%                   Currently available:
%                   'alpha' - confidnce level. The CI found is the
%                       100(1-alpha)% confidence region. By default,
%                       {alpha} = 0.05;
%                   'dimensions' - indicates a subset of dimensions to be
%                       used in the test. By default, all dimensions are
%                       taken.
%                   'samples' - indicates a subset of samples to be used in
%                       the test. By default, all samples are taken.
%                   'distribution' - can be either 'normal' (def) to
%                       indicate that the samples are assumed to be drawn
%                       from a normal distribution, and then the
%                       F-distribution is used, or it can be 'asymptotic'
%                       to indicate that there are many samples, so that
%                       the law of large numbers can be used, namely the
%                       chi2-distribution replaces the F-distribution.
% Output:      {ax} length of principal axes.
%              {cent} where the ellipsoid is centered.
%              {rot} rotation matrix, describing the axes rotation.

% © Liran Carmel
% Classification: Inference
% Last revision date: 18-Feb-2005

% parse input line
[data alpha dist] = parseInput(varargin{:});

% compute mean and covariance of the data
[no_dims no_samples] = size(data);
cent = mean(data,2);
scov = cov(data');

% eigendecomposition of covariance matrix
switch dist
    case 'normal'
        step_size = no_dims * (no_samples-1) / no_samples / ...
            (no_samples - no_dims) * finv(alpha,no_dims,no_samples-no_dims);
    case 'asymptotic'
        step_size = chi2inv(alpha,no_dims) / no_samples;
end
[rot D] = eig(scov);
ax = sqrt(step_size * diag(D));

% #########################################################################
function [data, alpha, dist] = parseInput(varargin)

% PARSEINPUT parses input line.
% ----------------------------------------
% [data alpha dist] = parseInput(varargin)
% ----------------------------------------
% Description: parses the input line.
% Input:       {varargin} original input line.
% Output:      {data} data matrix (variables-by-samples).
%              {alpha} determines the significance level.
%              {dist} distribution assumed.

% check number of input arguments
error(nargchk(1,Inf,nargin));

% first argument is always {vsm}
error(chkvar(varargin{1},{},'scalar',{mfilename,'',1}));
vsm = varargin{1};

% defaults
alpha = 0.05;
dims = 1:novariables(vsm);
samps = 1:nosamples(vsm);
dist = 'normal';

% loop on instructions
for ii = idx_instructions:2:nargin
    errmsg = {mfilename,'',ii+1};
    switch str2keyword(varargin{ii},4)
        case 'alph'     % instruction: alpha
            error(chkvar(varargin{ii+1},'numerical',...
                {'scalar',{'greaterthan',0},{'lowerthan',1}},...
                errmsg));
            alpha = varargin{ii+1};
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
        case 'dist'     % instruction: distribution
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            switch str2keyword(varargin{ii+1},4)
                case 'norm'
                    dist = 'normal';
                case 'asym'
                    dist = 'asymptotic';
                otherwise
                    error('%s: unfamiliar distribution',varargin{ii+1});
            end
        otherwise
            error('%s: unfamiliar instruction',upper(varargin{ii}));
    end
end

% get {data}
data = vsm(dims,samps);