function cov_int = gcovintra(varargin)

% GCOVINTRA computes the average intra-group covariance matrix.
% -------------------------------------------------
% cov_int = gcovintra(gr, data, h_level, estimator)
% -------------------------------------------------
% Description: computes the average intra-group covariance matrix.
% Input:       {gr} grouping instance.
%              {data} to apply covarince to. Can be either a collection of
%                   variable objects, or a variables-by-samples matrix.
%              <{h_level}> hierarchy level (def=1).
%              <{estimator}> determines the type of covariance estimator to
%                   use. Let {Si} be the maximum-likelihood esitmator of
%                   the i'th group, and let {ni} be the number of samples
%                   in that group. Then, the 'ml' estimator of {cov_int} is
%                   (see Webb, p. 215) {sum_i ni/n Si}. The 'unbiased'
%                   estimator (def) would be (there, p. 215) {sum_i
%                   ni/(n-g) Si}, where {g} is the number of groups.
% Output:      {cov_int} variables-by-variables average intra_group
%                   covariance matrix. 

% © Liran Carmel
% Classification: Computations on groups
% Last revision date: 02-Jul-2004

% parse input line
[gr data h_level estimator] = parse_input(varargin{:});

% get intra-group covariances
covs = gcov(gr,data,h_level,'ml');

% extract magnitudes that characterize the grouping
grp_size = groupsize(gr,h_level);
no_grp = nogroups(gr,h_level);
no_samp = nosamples(gr);

% compute "spinal" estimator of the average intra-group covariance
cov_int = 0;
for ii = 1:no_grp
    cov_int = cov_int + grp_size(ii)*covs(:,:,ii);
end

% normalize appropriately
switch estimator
    case 'unbiased'
        cov_int = cov_int / (no_samp - no_grp);
    case 'ml'
        cov_int = cov_int / no_samp;
end

% #########################################################################
function [gr, data, h_level, estimator] = parse_input(varargin)

% PARSE_INPUT parses input line.
% ---------------------------------------------------
% [gr data h_level estimator] = parse_input(varargin)
% ---------------------------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {gr} grouping instance.
%              {data} variables-by-samples data matrix.
%              {h_level} hierarchy level.
%              {estimator} either 'ml' or 'unbiased'.

% verify number of arguments
error(nargchk(2,4,nargin));

% first argument is the grouping
gr = varargin{1};
error(chkvar(gr,{},'scalar',{mfilename,'',1}));

% second argument is the data
[msg1 is_num] = chkvar(varargin{2},'numeric',{},{mfilename,'',2});
if is_num
    data = varargin{2};
    error(chkvar(data,{},{'matrix',{'no_cols',nosamples(gr)}},{mfilename,'',2}));
else
    [msg2 is_var] = chkvar(varargin{2},'variable',{},{mfilename,'',2});
    if is_var
        data = [];
        for ii = 1:length(varargin{2})
            vrii = instance(varargin{2},num2str(ii));
            data = [data ; vrii(1:end)];
        end
    else
        error('%s\n%s',msg1,msg2);
    end
end

% initialize optional arguments
h_level = 1;
estimator = 'unbiased';

% read next arguments
for ii = 3:nargin
    if isa(varargin{ii},'double')
        error(chkvar(varargin{ii},'integer',...
            {'scalar',{'greaterthan',0},{'eqlower',gr.no_hierarchies}},...
            {mfilename,'',ii}));
        h_level = varargin{ii};
    elseif isa(varargin{ii},'char')
        error(chkvar(varargin{ii},{},{'vector',{'match',{'unbiased','ml'}}},...
            {mfilename,'',ii}));
        estimator = varargin{ii};
    end
end