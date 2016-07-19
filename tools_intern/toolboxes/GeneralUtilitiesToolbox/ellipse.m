function ell = ellipse(varargin)

% ELLIPSE generate the coordinates of rotated and translated ellipse.
% ---------------------------------------------
% Ellipse = ellipse(ax, center, rot, no_points)
% ---------------------------------------------
% Description: generate the coordinates of rotated and translated ellipse.
% Input:       {ax} length-2 vector [a b], describing the principal axes of
%                   the ellipse.
%              <{center}> length-2 vector describing the coordinates of the
%                   center (def = [0 0]).
%              <{rot}> 2-by-2 totation matrix describing the axes rotation
%                 (def = eye(2)).
%              <{no_points}> number of points in the ellipse polygon is
%                   2*{no_points}-1 (def = 100). If {no_points} is zero,
%                   then {ell} = [].
% Output:      {ell} a polygon of (x,y) coordinates of the ellipse.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 12-Aug-2005

% parse input line
[a b center rot no_points] = parse_input(varargin{:});

% return if no points in the plot
if ~no_points
   ell = [];
   return;
end

% Plot elipse on the center of coordinates, not rotated
xd = linspace(-a,a,no_points);  % x down
xu = linspace(a,-a,no_points);  % x up
xu(1) = [];
yd = -b/a*sqrt(a^2 - xd.^2);  % y down
yu = b/a*sqrt(a^2 - xu.^2);   % y up

% Make a two row polygon
ell = [xd xu ; yd yu];

% Rotate and translate
ell = center'*ones(1,2*no_points-1) + rot*ell;

% #########################################################################
function [a, b, center, rot, no_points] = parse_input(varargin)

% PARSE_INPUT parses input line.
% --------------------------------------------------
% [a b center rot no_points] = parse_input(varargin)
% --------------------------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {a,b} principal axes.
%              {center} of ellipse.
%              {rot} rotation matrix.
%              {no_points} in the polygon.

% verify number of arguments
error(nargchk(1,4,nargin));

% first argument must be the axes
error(chkvar(varargin{1},'numeric',{'vector',{'length',2}},{mfilename,'',1}));
a = varargin{1}(1);
b = varargin{1}(2);

% defaults
center = [0 0];
rot = eye(2);
no_points = 100;

% loop on the rest of the input arguments
for ii = 2:nargin
    switch nodims(varargin{ii})
        case 0      % no_points
            no_points = varargin{ii};
        case 1      % center
            center = varargin{ii};
        case 2      % rot
            rot = varargin{ii};
        otherwise
            error('input arguments can be scalars, vector of matrices only');
    end
end