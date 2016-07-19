function sc = factorscores(cdata, lam, psi, algorithm)

% FACTORSCORES estimate the scores after factor analysis.
% ---------------------------------------------
% sc = factorscores(cdata, lam, psi, algorithm)
% ---------------------------------------------
% Description: estimate the scores after factor analysis.
% Input:       {cdata} centered data.
%              {lam} estimate of Lambda.
%              {psi} estimate of Psi.
%              {algorithm} there are some suggestions in literature how to
%                   do this. Currently implemented:
%                   {bartlett},{wls} - Bartlett's method, also known as the
%                           weighted-least-squares method.
% Output:      {sc} estimated scores.

% © Liran Carmel
% Classification: Linear transformations
% Last revision date: 30-Sep-2004

% generate inverse squared Psi
isPsi = diag(1./sqrt(psi));

% generate scores according to the chosen algorithm
switch algorithm
    case {'wls','bartlett'}
        sc = (isPsi*lam)\(isPsi*cdata);
end