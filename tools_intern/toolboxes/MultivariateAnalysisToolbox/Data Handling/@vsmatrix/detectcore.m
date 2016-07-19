function core = detectcore(varargin)

% DETECTCORE picks a dense group of samples forming the core of the data.
% --------------------------------------------------
% outliers = detectoutliers(vsm, i_name, i_val, ...)
% --------------------------------------------------
% Description: picks a dense group of samples that can be regarded as the
%              'core' of the data.
% Input:       {vsm} VSMATRIX instance.
%              <{i_name, i_value}> pairs that instruct how to use the
%                   detection algorithm. Currently available:
%                   'algorithm' - to use for core detection. By default,
%                           'Mahalanobis' is assumed with {span} equals to
%                           2.5. The entire list of options is:
%                       'Mahalanobis' - computes covariance matrix of the
%                           data, excludes those samples that have their
%                           Mahalanobis distance from the centroid more
%                           than {span}, recompute the covariance and
%                           repeat the exclusion until there are no samples
%                           left for exclusion.
%                   'span' - an algorithm-dependent parameter defining the
%                       span of the outlier detection.
%                   'samples' - indices of any subset of the samples of
%                       {vsm}. If 'all' (default), the entire data is
%                       considered.
%                   'dimensions' - indices of any subset of the variables
%                       of {vsm}. The core will be identified only in the
%                       correponding subspace. If 'all' (default), the
%                       entire variable space is considered.
% Output:      {core} list of samples that comprise the core of the data.

% © Liran Carmel
% Classification: Computations
% Last revision date: 28-Oct-2005

% parse input line
[vsm dims core algorithm span] = parseInput(varargin{:});

% switch on methods
switch algorithm
    case 'mahalanobis'
        % first iteration
        core_size = length(core);
        data = vsm.variables(dims,core);
        iS = inv(cov(data'));
        data = data - mean(data,2) * ones(1,core_size);
        dst = zeros(1,core_size);
        for ii = 1:core_size
            dst(ii) = data(:,ii)' * iS * data(:,ii);
        end
        to_remove = find(dst > span);
        % start iterations
        while ~isempty(to_remove)
            core(to_remove) = [];
            core_size = length(core);
            data = vsm.variables(dims,core);
            iS = inv(cov(data'));
            data = data - mean(data,2) * ones(1,core_size);
            dst = zeros(1,core_size);
            for ii = 1:core_size
                dst(ii) = data(:,ii)' * iS * data(:,ii);
            end
            to_remove = find(dst > span);
        end
end

% #########################################################################
function [vsm, dims, core, algorithm, span] = parseInput(varargin)

% PARSEINPUT parses input line.
% -----------------------------------------------------
% [vsm dims core algorithm span] = parseInput(varargin)
% -----------------------------------------------------
% Description: parses the input line.
% Input:       {varargin} original input line.
% Output:      {vsm} VSMATRIX instance.
%              {dims} subset of variables (dimension).
%              {core} initial indices of the core samples.
%              {algorithm} of core detection.
%              {span} width parameter of the algorithm.

% check number of input arguments
error(nargchk(1,Inf,nargin));

% first argument is always {vsm}
error(chkvar(varargin{1},{},'scalar',{mfilename,'',1}));
vsm = varargin{1};

% defaults
algorithm = 'mahalanobis';
span = 2.5;
core = 1:nosamples(vsm);
dims = 1:novariables(vsm);

% loop on instructions
for ii = 2:2:nargin
    errmsg = {mfilename,'',ii+1};
    switch str2keyword(varargin{ii},3)
        case 'alg'   % instruction: algorithm
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            switch str2keyword(varargin{ii+1},3)
                case 'mah'
                    algorithm = 'mahalanobis';
                    span = 2.5;
                otherwise
                    error('%s: unfamiliar core detection algorithm',...
                        varargin{ii+1});
            end
        case 'spa'   % instruction: span
            error(chkvar(varargin{ii+1},'double','scalar',errmsg));
            span = varargin{ii+1};
        case 'sam'   % instruction: samples
            if ischar(varargin{ii+1})
                switch str2keyword(varargin{ii+1},3)
                    case 'all'
                        core = 1:nosamples(vsm);
                    otherwise
                        error('%s: unfamiliar samples specification',...
                            varargin{ii+1});
                end
            else
                error(chkvar(varargin{ii+1},'integer',...
                    {'vector',{'greaterthan',0},{'eqlower',nosamples(vsm)}},...
                    errmsg));
                core = varargin{ii+1};
            end
        case 'dim'   % instruction: dimensions
            if ischar(varargin{ii+1})
                switch str2keyword(varargin{ii+1},3)
                    case 'all'
                        dims = 1:novariables(vsm);
                    otherwise
                        error('%s: unfamiliar dimension specification',...
                            varargin{ii+1});
                end
            else
                error(chkvar(varargin{ii+1},'integer',...
                    {'vector',{'greaterthan',0},{'eqlower',novariables(vsm)}},...
                    errmsg));
                dims = varargin{ii+1};
            end
        otherwise
            error('%s: unfamiliar instruction',upper(varargin{ii}));
    end
end

% square the span so that we don't have to take a SQRT each time we compute
% a Mahalanobis distance
span = span * span;