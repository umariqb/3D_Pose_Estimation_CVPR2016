function R = kendall(A,B)

% KENDALL computes the Kendall rank correlation matrix.
% ----------------
% R = kendall(A,B)
% ----------------
% Description: Computes the Kendall rank correlation matrix.
% Input:       {A} any data matrix variables-by-samples.
%              <{B}> any data matrix with the same number of
%                   measurement as in {A}. Basically, the rank correlation
%                   coefficients are calculated between the variables of
%                   {A} and {B}. If {B} is missing, the correlation
%                   coefficients are calculated between the variables of
%                   {A}.
% Output:      {R} Kendall rank correlations.

% © Liran Carmel
% Classification: Correlations
% Last revision date: 14-May-2004

% important notice: the Kendall correlation coefficient is defined as
%                    C - D
%       ---------------------------------
%       sqrt(C + D + T) * sqrt(C + D + U)
% where C is the number of concordant samples, D is the number of
% discordant samples, T is the number of ties in variable 1 (that are not
% ties in variable 2), and U is the number of ties in variable 2 (that are
% not ties in variable 1).

% Implementation: There is a fast algorithm that requires lots of space
% (no_samples-by-no_samples matrix). The original idea was to use it
% whenever no_samples < THRESHOLD. However, I experimentally found out that
% it is never fast, and actually always significantely slower than the
% "slow" algorithm. Therefore, I always use the "slow" algorithm that makes
% a double-loop over the samples.

% low-level input parsing
error(nargchk(1,2,nargin));
single_matrix_correlation = false;
if nargin == 1
    single_matrix_correlation = true;
end

% number of samples and type of algorithm
THRESHOLD = 1;
no_samples = size(A,2);
if no_samples > THRESHOLD
    algorithm = 'slow';
else
    algorithm = 'fast';
end

% one should consider each pair of variables separately
if single_matrix_correlation
    % initialize
    no_vars = size(A,1);
    R = eye(no_vars);
    % switch between algorithms
    switch algorithm
        case 'fast'
            % loop on pairs of variables
            for var_1 = 1:(no_vars-1)
                A_tmp = A(var_1,:)' * ones(1,no_samples);
                A_tmp = sign(A_tmp - A_tmp');
                for var_2 = (var_1+1):no_vars
                    B_tmp = A(var_2,:)' * ones(1,no_samples);
                    B_tmp = sign(B_tmp - B_tmp');
                    % find ties
                    T = length(find(~A_tmp & B_tmp));
                    U = length(find(A_tmp & ~B_tmp));
                    % find C and D
                    B_tmp = A_tmp .* B_tmp;
                    C = length(find(B_tmp==1));
                    D = length(find(B_tmp==-1));
                    R(var_1,var_2) = (C-D)/sqrt((C+D+T)*(C+D+U));
                    R(var_2,var_1) = R(var_1,var_2);
                end
            end
        case 'slow'
            % loop on pairs of variables
            for var_1 = 1:(no_vars-1)
                for var_2 = (var_1+1):no_vars
                    denom_l = 0;
                    denom_r = 0;
                    numer = 0;
                    % loop on pairs of samples
                    for samp_1 = 1:(no_samples-1)
                        for samp_2 = (samp_1+1):no_samples
                            diff_1 = A(var_1,samp_2) - A(var_1,samp_1);
                            diff_2 = A(var_2,samp_2) - A(var_2,samp_1);
                            mult = (diff_1)*(diff_2);
                            if mult
                                denom_l = denom_l + 1;
                                denom_r = denom_r + 1;
                                if mult > 0
                                    numer = numer + 1;
                                else
                                    numer = numer - 1;
                                end
                            else
                                if diff_1
                                    denom_r = denom_r + 1;
                                end
                                if diff_2
                                    denom_l = denom_l + 1;
                                end
                            end
                        end
                    end
                    % compute tau
                    R(var_1,var_2) = numer / sqrt(denom_l*denom_r);
                    R(var_2,var_1) = R(var_1,var_2);
                end
            end
    end
else
    % initialize
    no_vars_rows = size(A,1);
    no_vars_cols = size(B,1);
    R = zeros(no_vars_rows,no_vars_cols);
    % switch between algorithms
    switch algorithm
        case 'fast'
            % loop on pairs of variables
            for var_1 = 1:no_vars_rows
                A_tmp = A(var_1,:)' * ones(1,no_samples);
                A_tmp = sign(A_tmp - A_tmp');
                for var_2 = 1:no_vars_cols
                    B_tmp = B(var_2,:)' * ones(1,no_samples);
                    B_tmp = sign(B_tmp - B_tmp');
                    % find ties
                    T = length(find(~A_tmp & B_tmp));
                    U = length(find(A_tmp & ~B_tmp));
                    % find C and D
                    B_tmp = A_tmp .* B_tmp;
                    C = length(find(B_tmp==1));
                    D = length(find(B_tmp==-1));
                    R(var_1,var_2) = (C-D)/sqrt((C+D+T)*(C+D+U));
                end
            end
        case 'slow'
            % loop on pairs of variables
            for var_1 = 1:no_vars_rows
                for var_2 = 1:no_vars_cols
                    denom_l = 0;
                    denom_r = 0;
                    numer = 0;
                    % loop on pairs of samples
                    for samp_1 = 1:(no_samples-1)
                        for samp_2 = (samp_1+1):no_samples
                            diff_1 = A(var_1,samp_2) - A(var_1,samp_1);
                            diff_2 = B(var_2,samp_2) - B(var_2,samp_1);
                            mult = (diff_1)*(diff_2);
                            if mult
                                denom_l = denom_l + 1;
                                denom_r = denom_r + 1;
                                if mult > 0
                                    numer = numer + 1;
                                else
                                    numer = numer - 1;
                                end
                            else
                                if diff_1
                                    denom_r = denom_r + 1;
                                end
                                if diff_2
                                    denom_l = denom_l + 1;
                                end
                            end
                        end
                    end
                    % compute tau
                    R(var_1,var_2) = numer / sqrt(denom_l*denom_r);
                end
            end
    end
end