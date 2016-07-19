function C = microarraycolormap(scheme,N)

% MICROARRAYCOLORMAP returns a colormap for visualizing gene expression.
% ---------------------------------
% C = microarraycolormap(scheme, N)
% ---------------------------------
% Description: returns a colormap for visualizing gene expression.
% Input:       <{scheme}> color scheme. Available schemes are 'green-red'
%                   (def), 'blue-yellow' and 'yellow'.
%              <{N}> resolution of the colormap (def = 64).
% Output:      {C} is an {N}-by-3 colormap matrix.

% © Liran Carmel, based on the code of Michael Driscoll (Matlab Central)
% Classification: Coloring and colormaps
% Last revision date: 04-Mar-2006

% generally speaking, the two-colored maps are appropriate for visualizing
% expression data which is normalized to a reference condition, e.g. to
% show whether expression is lower (blue or green) or higher (yellow or
% red) than the reference.
%
% the single-color yellow map ('yellow') is appropriate for displaying
% levels of gene expression which are not compared (necessarily) to a
% single reference, and this is similar to the colormap used in the D-chip
% expression analysis software.
% 

% parse input line
if nargin == 0
    scheme = 'green-red';
    N = 64;
elseif nargin == 1
    if ischar(scheme)
        N = 64;
    else
        N = scheme;
        scheme = 'green-red';
    end
end

% compute colormap
X = 0.5:-1/(N-1):-0.5;
X = abs(X).*2;

switch scheme
    case 'green-red'
        R = [X(:, 1:N/2) zeros(1,N/2)];
        G = [zeros(1, N/2) X(:,(N/2 + 1):N)];
        B = zeros(1,N);
    case 'blue-yellow'
        R = [zeros(1,N/2) X(:,(N/2 + 1):N)];
        B = [X(:,1:N/2) zeros(1,N/2)];
        G = [zeros(1,N/2) X(:,(N/2 + 1):N)];
    case 'yellow'
        X = 0:1/(N - 1):1;
        R = X;
        B = zeros(1,N);
        G = X;
    otherwise
        error([scheme ' is not a known option for coloring']);
end

% return
C = [R' G' B'];