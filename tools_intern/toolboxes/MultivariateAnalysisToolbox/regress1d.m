function p = regress1d(x,y,reg_type)

% REGRESS1D linearly regress one variable on another.
% -----------------------------
% p = regress1d(x, y, reg_type)
% -----------------------------
% Description: linearly regress one variable {y} on another {x}.
% Input:       {x} numerical vector.
%              {y} another numerical vector, same length as {x}.
%              <{reg_type}> either 'intercept' (def) or 'slope' to
%                   descriminate between the two models y = a*x + b
%                   (intercept) and y = a*x (slope).
% Output:      {p} regression coefficients, either [a b] for 'intercept',
%                   or just a for 'slope'.

% © Liran Carmel
% Classification: Regression analysis
% Last revision date: 27-Feb-2004

% parse input
if nargin == 2
    reg_type = 'intercept';
end

% perform regression
switch reg_type
    case 'intercept'
        p = polyfit(x,y,1);
    case 'slope'
        p = sum(x.*y) / sum(x.^2);
end