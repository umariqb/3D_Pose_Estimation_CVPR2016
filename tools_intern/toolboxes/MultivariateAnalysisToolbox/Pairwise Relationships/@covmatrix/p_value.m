function cvm = p_value(cvm,test)

% P_VALUE computes p_values for cov/corr matrices.
% -----------------------------
% cvm = p_value(cvm, test_name)
% -----------------------------
% Description: computes p_values for covariance/correlation matrices.
% Input:       {cvm} covmatrix instance.
%              {test_name} is the identifier of the test to be taken. List
%                   of available tests depend on the kind of cvm matrix. To
%                   see a list the fits a certain kind, type p_value(cvm)
%                   without a second argument.
% Output:      {cvm} updated covmatrix instance.

% © Liran Carmel
% Classification: Statistical computations
% Last revision date: 24-Sep-2004

% check if a second argument was inserted
error(nargchk(1,2,nargin));
if nargin == 1
    error(chkvar(cvm,{},'scalar',{mfilename,inputname(1),1}));
    if isempty(cvm.cov_type)
        str = sprintf('No available tests for empty %s matrices:',...
            get(cvm,'type'));
    else
        str = sprintf('Available test for %s %s matrices:',...
            cvm.cov_type,get(cvm,'type'));
    end
    disp(str)
    switch cvm.cov_type
        case 'pearson'
            switch get(cvm,'type')
                case 'covariance'
                    disp('   None');
                case 'correlation'
                    disp('   Independence (t-test), type ''independence''');
            end
        case 'spearman'
            % no covariance is defined
            disp('   Independence (t-test), type ''independence''');
        case 'kendall'
            % no covariance is defined
            disp('   Independence (z-test), type ''independence''');
        case ''
            disp('   None');
    end
    cvm = [];
    return;
end

% perform test
switch cvm.cov_type
    case 'pearson'
        switch get(cvm,'type')
            case 'covariance'
            case 'correlation'
                switch str2keyword(test,4)
                    case 'inde'
                        R = get(cvm,'matrix');
                        % transform into a t-distributed variable
                        warning('off','MATLAB:divideByZero');
                        t = R ./ sqrt(1 - R.^2) .* sqrt(cvm.no_samples - 2);
                        warning('on','MATLAB:divideByZero');
                        % Given the varaibles are independent, t is known
                        % to be distributed according to t-distribution
                        % with n-2 DOF
                        p_val = 2 * tcdf(-abs(t),cvm.no_samples-2);
                        % substitute in class
                        idx = find(strcmp(cvm.hypothesis,'independence (t-test)'));
                        if isempty(idx)
                            cvm.hypothesis = [cvm.hypothesis {'independence (t-test)'}];
                            cvm.p_value = [cvm.p_value {p_val}];
                        else
                            cvm.p_value{idx} = p_val;
                        end
                end
        end
    case 'spearman'
        % no covariance is defined
        switch str2keyword(test,4)
            case 'inde'
                R = get(cvm,'matrix');
                % transform into a t-distributed variable
                warning('off','MATLAB:divideByZero');
                t = R .* sqrt( (cvm.no_samples - 2)./(1 - R.^2) );
                warning('on','MATLAB:divideByZero');
                % Given the varaibles are independent, t is known
                % to be approximately distributed according to
                % t-distribution with n-2 DOF
                p_val = 2 * tcdf(-abs(t),cvm.no_samples-2);
                % substitute in class
                idx = find(strcmp(cvm.hypothesis,'independence (t-test)'));
                if isempty(idx)
                    cvm.hypothesis = [cvm.hypothesis {'independence (t-test)'}];
                    cvm.p_value = [cvm.p_value {p_val}];
                else
                    cvm.p_value{idx} = p_val;
                end
        end
    case 'kendall'
        % no covariance is defined
        switch str2keyword(test,4)
            case 'inde'
                R = get(cvm,'matrix');
                % R is approximately normally distributed with zero mean
                % and with variance
                vr = (4*cvm.no_samples+10)./(9*cvm.no_samples.*(cvm.no_samples-1));
                % the p-value is therefore  
                p_val = 2 * normcdf(-abs(R),0,sqrt(vr));
                % substitute in class
                idx = find(strcmp(cvm.hypothesis,'independence (z-test)'));
                if isempty(idx)
                    cvm.hypothesis = [cvm.hypothesis {'independence (z-test)'}];
                    cvm.p_value = [cvm.p_value {p_val}];
                else
                    cvm.p_value{idx} = p_val;
                end
        end
end