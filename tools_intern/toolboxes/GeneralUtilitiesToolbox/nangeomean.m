function mu = nangeomean(x,dim)

% NANGEOMEAN computes geometrical mean, ignoring NaNs.
% -----------------------
% mu = nangeomean(x, dim)
% -----------------------
% Description: computes geometrical mean, ignoring NaNs.
% Input:       {x} a data array.
%              {dim} dimension to work along (def = 1).
% Output:      {mu} geometrical mean.

% © Liran Carmel
% Classification: Information extraction
% Last revision date: 12-Oct-2007

% Find NaNs and set them to zero
nans = isnan(x);
x(nans) = 1;

if nargin == 1 % let sum deal with figuring out which dimension to use
    % Count up non-NaNs.
    n = sum(~nans);
    n(n==0) = NaN; % prevent divideByZero warnings
    % Sum up non-NaNs, and divide by the number of non-NaNs.
    mu = exp(sum(log(x)) ./ n);
else
    % Count up non-NaNs.
    n = sum(~nans,dim);
    n(n==0) = NaN; % prevent divideByZero warnings
    % Sum up non-NaNs, and divide by the number of non-NaNs.
    mu = exp(sum(log(x),dim) ./ n);
end