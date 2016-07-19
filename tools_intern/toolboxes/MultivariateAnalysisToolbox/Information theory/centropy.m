function [Hx_y, Hx_yi] = centropy(Px_yi, Py)

% CENTROPY computes the conditional entropy between two variables.
% -----------------------------------
% [Hx_y, Hx_yi] = centropy(Px_yi, Py)
% -----------------------------------
% Description: computes the conditional entropy between two variables. Let
%              {X} by a RV with {nx} possible discrete states, and let {Y}
%              be a RV with {ny} discrete states. We compute both H(X|Y=yi)
%              for all {ny} possible y's, and H(X|Y).
% Input:       {Px_yi} matrix of dimensions {ny}-by-{nx}, where each row is
%                   the probability distribution P(X|Y=yi).
%              {Py} marginal distribution of Y.
% Output:      {Hx_y} the conditional entropy H(X|Y).
%              {Hx_yi} vector of length {ny} indicating the conditional
%                   entropies H(X|Y=yi}.

% © Liran Carmel
% Classification: Basic functions
% Last revision date: 28-Jun-2004

% check input
error(nargchk(2,2,nargin));
error(chkvar(Px_yi,'numeric',{'matrix',{'sumto',1}},{mfilename,inputname(1),1}));
error(chkvar(Py,'numeric',{'vector',{'sumto',1},{'length',size(Px_yi,1)}},...
        {mfilename,inputname(2),2}));

% calculate conditional entropy
ny = size(Px_yi,1);
Hx_yi = zeros(1,ny);
Hx_y = 0;
for ii = 1:ny
    Hx_yi(ii) = entropy(Px_yi(ii,:));
    Hx_y = Hx_y + Py(ii)*Hx_yi(ii);
end