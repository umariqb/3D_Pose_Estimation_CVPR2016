function cvm = correlate(vsm,cov_type)

% CORRELATE computes covariance/correlation matrix.
% ------------------------------
% cvm = correlate(vsm, cov_type)
% ------------------------------
% Description: computes covariance/correlation matrix.
% Input:       {vsm} instance of the vsmatrix class.
%              <{cov_type}> any of 'pearson' (def), 'spearman' or
%                   'kendall'.
% Output:      {cvm} correlation matrix.

% © Liran Carmel
% Classification: Computations
% Last revision date: 24-Sep-2004

% parse input line
error(nargchk(1,2,nargin))
error(chkvar(vsm,{},'scalar',{mfilename,inputname(1),1}));
if nargin == 1
    cov_type = 'pearson';
else
    error(chkvar(cov_type,'char','vector',{mfilename,inputname(2),2}));
end
switch lower(cov_type)
    case 'pearson'
        corr_func = @pearson;
    case 'spearman'
        corr_func = @spearman;
    case 'kendall'
        corr_func = @kendall;
    otherwise
        error('%s: Unrecognized type of correlation',upper(cov_type));
end

% initialization
cvm = covmatrix;
cvm = set(cvm,'cov_type',cov_type);
no_samples = nosamples(vsm);
no_variables = novariables(vsm);
n = no_samples*ones(no_variables);
R = zeros(no_variables);

% name of the matrix
vsm_name = get(vsm,'name');
name = sprintf('%s%s Correlation',upper(cov_type(1)),cov_type(2:end));
if ~isempty(vsm_name)
    name = sprintf('%s (%s vsmatrix)',name,vsm_name);
end

% description field
vsm_desc = get(vsm,'description');
desc = '';
if ~isempty(vsm_desc)
    desc = sprintf('data description: %s',vsm_desc);
end

% correlations between complete variables
is_comp = find(iscomplete(vsm.variables));
if ~isempty(is_comp)
    R(is_comp,is_comp) = corr_func(vsm.variables(is_comp,:));
end

% remove missing data for incomplete variables
is_incomp = allbut(is_comp,no_variables);
% loop on incomplete variables
for ii = 1:length(is_incomp)
    var_1 = is_incomp(ii);
    [data idx] = nanless(vsm.variables(var_1));
    len = length(data);
    R(var_1,var_1) = 1;
    n(var_1,var_1) = len;
    % correlate with another complete variable
    for jj = 1:length(is_comp)
        var_2 = is_comp(jj);
        R(var_1,var_2) = corr_func(data,vsm.variables(var_2,idx));
        R(var_2,var_1) = R(var_1,var_2);
        n(var_1,var_2) = len;
        n(var_2,var_1) = len;
    end
    % correlate with another incomplete variable
    for jj = ii+1:length(is_incomp)
        var_2 = is_incomp(jj);
        % take complete data
        [data idx_2] = nanless(vsm.variables(var_2));   %#ok
        merged = intersect(idx,idx_2);
        if isempty(merged)
            R(var_1,var_2) = NaN;
            R(var_2,var_1) = NaN;
            n(var_1,var_2) = 0;
            n(var_2,var_1) = 0;
        else
            R(var_1,var_2) = corr_func(vsm.variables(var_1,merged), ...
                vsm.variables(var_2,merged));
            R(var_2,var_1) = R(var_1,var_2);
            n(var_1,var_2) = length(merged);
            n(var_2,var_1) = length(merged);
        end
    end
end

% substitute in cvm
cvm = set(cvm,'name',name,'description',desc,'type','correlation',...
    'sampleset',vsm.variables(:).name,'matrix',R,'cov_type',cov_type,...
    'no_samples',n);

% update p-value
cvm = p_value(cvm,'independence');