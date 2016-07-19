function [low, up] = ci(cvm,type,level)

% CI computes confidence intervals for cov/corr matrices.
% -------------------------------
% [low up] = ci(cvm, type, level)
% -------------------------------
% Description: computes confidence intervals for covariance/correlation matrices.
% Input:       {cvm} covmatrix instance.
%              {type} either 'symmetric'.
%              {level} is the confidence level of the interval.
% Output:      {low} lower bound of CI.
%              {up} upper bound of CI.

% © Liran Carmel
% Classification: Statistical computations
% Last revision date: 02-Sep-2004

% parse input line
error(nargchk(3,3,nargin));

% perform test
switch cvm.cov_type
    case 'pearson'
        switch get(cvm,'type')
            case 'covariance'
            case 'correlation'
                switch str2keyword(type,4)
                    case 'symm'
                        % perform Fisher transformation
                        z = atanh(get(cvm,'matrix'));
                        % interval size for the z-statistic
                        a = 1./sqrt(cvm.no_samples) .* norminv(0.5*(1 + level));
                        % substitute in class
                        low = tanh(z-a);
                        up = tanh(z+a);
                end
        end
    case 'spearman'
    case 'kendall'
end