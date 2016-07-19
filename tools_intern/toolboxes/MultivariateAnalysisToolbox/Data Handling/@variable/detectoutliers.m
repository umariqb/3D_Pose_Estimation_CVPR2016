function outliers = detectoutliers(varargin)

% DETECTOUTLIERS detects outliers in variable(s).
% -------------------------------------------------
% outliers = detectoutliers(vr, i_name, i_val, ...)
% -------------------------------------------------
% Description: detects outliers in variable(s).
% Input:       {vr} VARIABLE instance(s).
%              <{i_name, i_value}> pairs that instruct how to use the
%                   detection algorithm. Currently available:
%                   'algorithm' - to use for outlier detection. Can be:
%                       'std' - Let m and s be the mean and std of the
%                           variable. This method detects all samples that
%                           are not in the range [m-span*s, m+span*s],
%                           where {span} is a parameter (see 'span' below).
%                           By default, {span} = 2.5. This is the default
%                           method.
%                       'norminv' - Let m be the mean of the variable, and
%                           let N be its number of samples. Let {q} be the
%                           value whose normal-CDF is 1/2/N. The meaning is
%                           that by average we will detect exactly one
%                           sample (if the variable is normally
%                           distributed) outside of the range [m+q, m-q]. 
%                           In practice, we add a span to this algorithm,
%                           by defining {q} as the value whose normal-CDF
%                           is 1/2/N/span. By default, {span} = 1.
%                       'quartile' - Let q1 and q2 be the 0.25 and 0.75
%                           quartiles of the variable, respectively, and
%                           let r = q2-q1. Outliers are defined as those
%                           samples that are outside the range [q1-span*r,
%                           q2+span*r].
%                   'span' an algorithm-dependent parameter defining the
%                       span of the outlier detection.
% Output:      {outliers} list of outliers. It is a vector if {vr} is
%                   scalar, and cell array otherwise.

% © Liran Carmel
% Classification: Analysis
% Last revision date: 24-Aug-2006

% parse input line
[vr algorithm span] = parseInput(varargin{:});

% switch on methods
switch algorithm
    case 'std'
        % get information
        m = mean(vr);
        srange = span * std(vr);
        % identify outliers
        if isscalar(vr)
            outliers = [find(vr > m+srange) find(vr < m-srange)];
        else
            outliers = cell(size(vr));
            for ii = 1:numel(vr)
                outliers{ii} = [find(vr(ii) > m(ii)+srange(ii)) ...
                    find(vr(ii) < m(ii)-srange(ii))];
            end
        end
    case 'norminv'
        % get information
        m = mean(vr);
        s = std(vr);
        % identify outliers
        if isscalar(vr)
            nrange = m - norminv(1/2/nosamples(vr)/span,m,s);
            outliers = [find(vr > m+nrange) find(vr < m-nrange)];
        else
            outliers = cell(size(vr));
            for ii = 1:numel(vr)
                nrange = m(ii) - ...
                    norminv(1/2/nosamples(vr(ii))/span,m(ii),s(ii));
                outliers{ii} = [find(vr(ii) > m(ii)+nrange) ...
                    find(vr(ii) < m(ii)-nrange)];
            end
        end
    case 'quartile'
        % get information
        quart = quantile(vr,[0.25 0.75]);
        qrange = span * iqr(vr);
        % identify outliers
        if isscalar(vr)
            outliers = [find(vr > quart(2)+qrange) ...
                find(vr < quart(1)-qrange)];
        else
            outliers = cell(size(vr));
            for ii = 1:numel(vr)
                outliers{ii} = [find(vr(ii) > quart{ii}(2)+qrange(ii)) ...
                    find(vr(ii) < quart{ii}(1)-qrange(ii))];
            end
        end
end

% #########################################################################
function [vr, algorithm, span] = parseInput(varargin)

% PARSEINPUT parses input line.
% ------------------------------------------
% [vr algorithm span] = parseInput(varargin)
% ------------------------------------------
% Description: parses the input line.
% Input:       {varargin} original input line.
% Output:      {vr} VARIABLE instance(s).
%              {algorithm} of outlier detection.
%              {span} width parameter of the algorithm.

% check number of input arguments
error(nargchk(1,Inf,nargin));

% first argument is always {vr}
vr = varargin{1};

% defaults
algorithm = 'std';
span = 2.5;

% loop on instructions
for ii = 2:2:nargin
    errmsg = {mfilename,'',ii+1};
    switch str2keyword(varargin{ii},3)
        case 'alg'   % instruction: algorithm
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            switch str2keyword(varargin{ii+1},3)
                case 'std'
                    algorithm = 'std';
                    span = 2.5;
                case 'nor'
                    algorithm = 'norminv';
                    span = 1;
                case 'qua'
                    algorithm = 'quartile';
                    span = 1.5;
                otherwise
                    error('%s: unfamiliar outlier detection algorithm',...
                        varargin{ii+1});
            end
        case 'spa'   % instruction: span
            error(chkvar(varargin{ii+1},'double','scalar',errmsg));
            span = varargin{ii+1};
        otherwise
            error('%s: unfamiliar instruction',upper(varargin{ii}));
    end
end