function outliers = detectoutliers(vsm,varargin)

% DETECTOUTLIERS detects outliers in the variables of a vsmatrix.
% --------------------------------------------------
% outliers = detectoutliers(vsm, i_name, i_val, ...)
% --------------------------------------------------
% Description: detects outliers in the variables of a vsmatrix.
% Input:       {vsm} VSMATRIX instance.
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
% Output:      {outliers} list of outliers. Here, it unites all outliers
%                   detected in all variables, into a joint list. If
%                   desired to get different lists for different variables,
%                   one can use detectoutliers(vsm.variables,...).

% © Liran Carmel
% Classification: Computations
% Last revision date: 10-Feb-2005

% parse input line
error(chkvar(vsm,{},'scalar',{mfilename,inputname(1),1}));

% call outlier detector of each variable
out = detectoutliers(vsm.variables,varargin{:});

% merge outliers
no_vars = novariables(vsm);
if no_vars == 1
    outliers = out;
else
    outliers = [];
    for ii = 1:no_vars
        outliers = [outliers out{ii}];
    end
    outliers = unique(outliers);
end