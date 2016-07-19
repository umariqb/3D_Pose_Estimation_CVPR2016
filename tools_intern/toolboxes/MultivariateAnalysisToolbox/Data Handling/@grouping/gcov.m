function covs = gcov(varargin)

% GCOV computes intra-group covariances
% -----------------------------------------
% covs = gcov(gr, data, h_level, estimator)
% -----------------------------------------
% Description: If a dataset contains {g} groups in the {h_level} hierarchy,
%              then this function computes the {g} intra-group covariances.
% Input:       {gr} grouping instance.
%              {data} to apply covarince to. Can be either a collection of
%                   variable objects, or a variables-by-samples matrix.
%              <{h_level}> hierarchy level (def=1).
%              <{estimator}> determines the type of covariance estimator to
%                   use. Can be either 'unbiased' (def), where the inner
%                   product is normalized by (no_samples-1), or it can be
%                   'ml' (maximum-likelihood), where the inner product is
%                   normalized by no_samples.
% Output:      {covs} variables-by-variables-by-number_of_groups computed
%                   covariances. 

% © Liran Carmel
% Classification: Computations on groups
% Last revision date: 02-Jul-2004

% parse input line
[gr data h_level estimator] = parse_input(varargin{:});

% initialize
no_vars = size(data,1);
no_groups = nogroups(gr,h_level);
covs = zeros(no_vars,no_vars,no_groups);

% calculate the covariances
switch estimator
    case 'unbiased'
        for ii = 1:no_groups
            covs(:,:,ii) = cov(data(:,grp2samp(gr,gr.gcn2gid{h_level}(ii),h_level))');
        end
    case 'ml'
        for ii = 1:no_groups
            covs(:,:,ii) = cov(data(:,grp2samp(gr,gr.gcn2gid{h_level}(ii),h_level))',1);
        end
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
%              {estimator} either 'unbiased' or 'ml'.

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