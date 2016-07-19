function cvm = correlate(varargin)

% CORRELATE computes covariance/correlation matrix.
% -----------------------------------
% cvm = correlate(ds, cov_type, vars)
% -----------------------------------
% Description: computes covariance/correlation matrix.
% Input:       {ds} instance of the dataset class.
%              <{cov_type}> any of 'pearson' (def), 'spearman' or
%                   'kendall'.
%              <{vars}> which variables of the dataset to take (def=all).
% Output:      {cvm} correlation matrix.

% © Liran Carmel
% Classification: Computations
% Last revision date: 03-Jan-2004

% parse input line
[ds cov_type corr_func vars no_samples] = parse_input(varargin{:});

% initialization
cvm = covmatrix;
no_variables = length(vars);
n = no_samples*ones(no_variables);
R = zeros(no_variables);

% name of the matrix
name = sprintf('%s%s Correlation of the %s datamatrix',...
    upper(cov_type(1)),cov_type(2:end),ds.name);

% correlations between complete variables
is_comp = find(iscomplete(ds.variables(vars)));
if ~isempty(is_comp)
    R(is_comp,is_comp) = corr_func(ds.variables(vars(is_comp),:));
end

% remove missing data for incomplete variables
is_incomp = allbut(is_comp,no_variables);
% loop on incomplete variables
for ii = 1:length(is_incomp)
    var_1 = is_incomp(ii);
    [data idx] = nanless(ds.variables(vars(var_1)));
    len = length(data);
    R(var_1,var_1) = 1;
    n(var_1,var_1) = len;
    % correlate with another complete variable
    for jj = 1:length(is_comp)
        var_2 = is_comp(jj);
        R(var_1,var_2) = corr_func(data,ds.variables(vars(var_2),idx));
        R(var_2,var_1) = R(var_1,var_2);
        n(var_1,var_2) = len;
        n(var_2,var_1) = len;
    end
    % correlate with another incomplete variable
    for jj = ii+1:length(is_incomp)
        var_2 = is_incomp(jj);
        % take complete data
        [data idx_2] = nanless(ds.variables(vars(var_2)));  %#ok
        merged = intersect(idx,idx_2);
        if isempty(merged)
            R(var_1,var_2) = NaN;
            R(var_2,var_1) = NaN;
            n(var_1,var_2) = 0;
            n(var_2,var_1) = 0;
        else
            R(var_1,var_2) = corr_func(ds.variables(vars(var_1),merged), ...
                ds.variables(vars(var_2),merged));
            R(var_2,var_1) = R(var_1,var_2);
            n(var_1,var_2) = length(merged);
            n(var_2,var_1) = length(merged);
        end
    end
end

% substitute in cvm
cvm = set(cvm,'name',name,...
    'description',sprintf('data description: %s',ds.description),...
    'type','correlation',...
    'sampleset',ds.variables(vars).name,...
    'matrix',R,'cov_type',cov_type,'no_samples',n);

% update p-value
cvm = p_value(cvm,'independence');

% #########################################################################
function [ds, cov_type, corr_func, vars, no_samples] = parse_input(varargin)

% PARSE_INPUT parses input line.
% ---------------------------------------------------------------
% [ds cov_type corr_func vars no_samples] = parse_input(varargin)
% ---------------------------------------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {ds} dataset object.
%              {cov_type} either 'pearson', 'spearman', and 'kendall'.
%              {corr_func} function handle to the function corresponding to
%                   {cov_type}.
%              {vars} indices of variables to correlate.
%              {no_samples} total number of samples.

% verify number of arguments
error(nargchk(1,3,nargin));

% first argument is always the dataset
ds = varargin{1};
error(chkvar(ds,{},'scalar',{mfilename,inputname(1),1}));

% set defaults
cov_type = 'pearson';
corr_func = @pearson;
vars = 1:novariables(ds);

% loop on the arguments
for ii = 2:nargin
    [msg1 is_char] = chkvar(varargin{ii},'char','vector',...
        {mfilename,'',ii});
    if is_char
        cov_type = varargin{ii};
        switch lower(cov_type)
            case 'pearson'
                corr_func = @pearson;
            case 'spearman'
                corr_func = @spearman;
            case 'kendall'
                corr_func = @kendall;
            otherwise
                error('%s: Unrecognized correlation',upper(cov_type));
        end
    else
        [msg2 is_int] = chkvar(varargin{ii},'integer',...
            {'vector',{'eqlower',novariables(ds)}},...
            {mfilename,'',ii});
        if is_int
            vars = varargin{ii};
        else
            error('%s\n%s',msg1,msg2);
        end
    end
end

% check consistency - all variables should have the same no_samples
no_samples = unique(nosamples(ds,vars));
if length(no_samples) ~= 1
    error('All variables should have the same number of samples');
end