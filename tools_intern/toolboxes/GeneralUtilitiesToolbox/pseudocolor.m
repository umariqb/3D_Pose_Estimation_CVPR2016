function pseudocolor(varargin)

% PSEUDOCOLOR pseudoclor map of a matrix.
% -----------------------------
% pseudocolor(x, y, c, c_scale)
% -----------------------------
% Description: pseudoclor map of a matrix. It is an improved version of
%              Matlab's PCOLOR, that shows also the last column and row,
%              and can scale the colorbar.
% Input:       <{x}> defines the x-grid, see PCOLOR. Mandatory if {y} is
%                   present.
%              <{y}> defines the y-grid, see PCOLOR. Mandatory if {x} is
%                   present.
%              {c} data matrix.
%              <{c_scale}> 2-by-1 vector of [cmin cmax], determining the
%                   lower and upper bound of the color scaling. Inf instead
%                   of {cmax} takes the highest data point, while -Inf
%                   instead of {cmin} takes the lowest data point.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 18-Apr-2007

% parse input
c_scale = [-Inf Inf];
switch nargin
    case 1
        c = varargin{1};
    case 2
        c = varargin{1};
        c_scale = varargin{2};
    case 3
        x = varargin{1};
        y = varargin{2};
        c = varargin{3};
    case 4
        x = varargin{1};
        y = varargin{2};
        c = varargin{3};
        c_scale = varargin{4};
end

% process {c_scale}
if isinf(c_scale(1))
    c_scale(1) = min2(c);
end
if isinf(c_scale(2))
    c_scale(2) = max2(c);
end

% add empty row and column
[rows cols] = size(c);
c = [[c c_scale(1)*ones(rows,1)] ; c_scale(2)*ones(1,cols+1)];
if nargin > 2
    x = [x 2*x(end)-x(end-1)];
    y = [y 2*y(end)-y(end-1)];
end
%c(1,end) = c_scale(1);
%c(end,1) = c_scale(2);

% plot
if nargin < 3
    pcolor(c);
else
    pcolor(x,y,c);
end
shading flat
colorbar