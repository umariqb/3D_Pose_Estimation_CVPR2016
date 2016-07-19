function [h,hcb] = imagescnan(x,y,U,varargin)
%IMAGESCNAN Scale data and display as image with uncolored NaNs.
%
%   Syntax
%               imagescnan(x,y,U)
%               imagescnan(x,y,U,...,colormask)
%               imagescnan(x,y,U,...,color)
%               imagescnan(x,y,U,...,cbfit_opt)
%           h = imagescnan(...);
%     [h,hcb] = imagescnan(...,cbfit_opt);
%
%   Input:
%     x          - X-axis vector data. Optional, i.e., can be empty.
%                  Default: 1:n (rows index).
%     y          - Y-axis vector data. Optional, i.e., can be empty.
%                  Default: 1:m (column index).
%     U          - Matrix [m x n] data or an RGB image [m x n x 3] (with/
%                  without NaNs). 
%     colormask  - Logical matrix indicating the U elements to be
%                  uncolored, if is empty then ISNAN(U) is used. Or it can
%                  be a single value which will be uncolored.
%                  Default: ~isfinite(U) (NaNs and Infs elements uncolored)
%     color      - A vector with 3 elements specifying the [R G B] color
%                  for the NaNs color. It can be specified by the known
%                  char colors: 'k', etcerera. Optional.  
%                  Default: get(gca,'color') (axes background color)
%     cbfit_opt  - Cell array with the options to call COLORBARFIT.
%                  Default: COLORBARFIT function is not used by default.
%
%   Output:
%     h   - Image handle. Optional
%     hcb - Colorbar handle. Optional
%
%   Description:
%      This function draws a matrix data as an image with uncolored NaN's
%      elements using IMAGESC. The difference between IMAGESC and the
%      PCOLOR, MESH or SURF function is that EVERY element is colored and
%      no one is interpolated, besides, the pixels are centered with the
%      axis value, although it is a flat image.
%
%      The color mask is added because IMAGESC do not work with NaN's, in
%      fact it colors them with the lower value of the current colormap.
%      
%      The cbfit_opt is include in order to be able to define a diferent
%      color map with the COLORBARFIT function which can be found at:
%           http://www.mathworks.com/matlabcentral/fileexchange/.
%      If this function is not found, a normal COLORBAR is generated.
%
%      The data and the colorbar are scaled with the current colormap, so,
%      the use of COLORMAP after this function doesn't affects the
%      generated image and colorbar! Therefore, COLORMAP and CAXIS should
%      be used before this function.
%
%      Notes: * The inputs arguments for the COLORBARFIT function are 3
%               plus the normal COLORBAR function options, for this reason,
%               if the former is not found, the latter is used ignoring
%               these first 3 options. Anyway, to generate a colorbar, at
%               least an empty cell is needed for cbfit_opt = {[]}.
%   
%   Examples:
%
%      % Compares with normal IMAGESC:
%       N = 100;
%       PNaNs = 0.10;
%       X = peaks(N);
%       X(round(1 + (N^2-1).*rand(N^2*PNaNs,1))) = NaN;
%       subplot(221), imagesc(X)
%        title('With IMAGESC: ugly NaNs')
%       subplot(222), imagescnan([],[],X) 
%        title('With IMAGESCNAN: uncolored NaNs')
%
%      % Compares with SPY:
%       subplot(223), spy(isnan(X))
%        title('SPY NaNs')
%       subplot(224), imagescnan([],[],isnan(X),0), axis equal tight
%        title('No-NaNs with IMAGESCNAN')
%
%   See also IMAGE, IMAGESC, COLORBAR, IMREAD, IMWRITE and COLORBARFIT by
%   Carlos Vargas. 

%   Copyright 2008 Carlos Adrian Vargas Aguilera
%   $Revision: 1.3 $  $Date: 2008/07/11 11:07:00 $

%   Written by
%   M.S. Carlos Adrian Vargas Aguilera
%   Physical Oceanography PhD candidate
%   CICESE 
%   Mexico, 2008
%   nubeobscura@hotmail.com
%
%   Download from:
%   http://www.mathworks.com/matlabcentral/fileexchange/loadAuthor.do?objec
%   tType=author&objectId=1093874

%   1.0     Released (30/06/2008)
%   1.1     Fixed bug when CAXIS used.
%   1.2     Colorbar freezed colormap.
%   1.3     Fixed bug in color vector input (Found by Greg King) and now
%           accets RGB image as input.

%% INPUTS:

% Error checking:
% Note: At least 3 inputs and no more than 6:
if nargin<3 || nargin>6
 error('Imagescnan:IncorrectInputNumber',...
       'Input arguments must be at least 3 and less than 7.')
end

% Check the x,y,U:
% Note: x,y should be the axes data.
m = size(U);
if numel(m)>3
 error('Imagescnan:IncorrectInputSize',...
       'Input image must be a matrix or an RGB image.')
else
 if isempty(x) || numel(x)~=m(2)
  %warning('Imagescnan:IncorrectInputSize',...
  %        'Index column axis has been used.')
  x = 1:m(2); 
 end
 if isempty(y) || numel(y)~=m(1)
  %warning('Imagescnan:IncorrectInputSize',...
  %        'Index row axis has been used.')
  y = 1:m(1); 
 end
end

% Get color limits:
% Note: If you would like to use specific color limits, use CAXIS before
%       this function.
switch get(gca,'CLimMode')
 case 'manual'
  clim = caxis;
 otherwise
  clim = [min(U(:)) max(U(:))];
  if clim(1)==clim(2)
      clim(2)=clim(1)+eps;
  end
end

% Parse inputs and defaults:
% Note: * Mask color will be the not-finite elements plus the elements
%         indicated by the user.
%       * Default colormask is the current axes background.
%       * Default currentmap is current figure colormap (probably JET).
colormask = ~isfinite(U);
color_nan = get(gca,'color');
color_map = get(gcf,'colormap'); 
cbfit_opt = [];
ycolorbarfit = (exist('colorbarfit','file')==2);
if nargin>3
 while ~isempty(varargin)
  if     iscell(varargin{1})
   if length(varargin{1})<3
    error('Imagescnan:IncorrectInputType',...
     'Options for COLORBARFIT must be at least 3, although empty.')
   end
   caxis(clim)
   cbfit_opt = varargin{1};
   if ycolorbarfit
    colorbarfit(cbfit_opt{:})
    color_map = get(gcf,'colormap');
   else
    % warning('Imagescnan:ColorBarFitNotFound',...
    %  'COLORBARFIT function not found, used default COLORBAR.') 
   end
   varargin(1) = [];
  elseif ischar(varargin{1})
   switch varargin{1}
    case 'y', color_nan = [1 1 0];
    case 'm', color_nan = [1 0 0];
    case 'c', color_nan = [0 1 1];
    case 'r', color_nan = [1 0 0];
    case 'g', color_nan = [0 1 0];
    case 'b', color_nan = [0 0 1];
    case 'w', color_nan = [1 1 1];
    case 'k', color_nan = [0 0 0];
   otherwise
   error('Imagescnan:InvalidColor',...
    'Color char must be one of: ''ymcrgbwk''.')
   end
   varargin(1) = [];
  elseif islogical(varargin{1})
   if numel(varargin{1})~=numel(U)
    error('Imagescnan:InvalidMask',...
     'The logical mask must have the same elements as the matrix.')
   end
   colormask = varargin{1} | colormask;
   varargin(1) = [];
  elseif length(varargin{1})==3
   if (max(varargin{1})>1) || (min(varargin{1})<0) % Fixed BUG 2008/07/11
    error('Imagescnan:InvalidColor',...
     'The color must be on the range of [0 1].')
   end
   color_nan = varargin{1};
   varargin(1) = [];
  elseif length(varargin{1})==1
   colormask = (U==varargin{1}) | colormask;
   varargin(1) = [];
  else
   error('Imagescnan:IncorrectInputType',...
    'Incorrect optional(s) argument(s).')
  end
 end
end


%% MAIN:

% Matrix data to RGB:
if numel(m)==2

 % Sets to double data:
 if ~isfloat(U)
  U = double(U);
 end

 % Normalizes and rounds data to range [0 N]:
 N = size(color_map,1);
 U = (U - clim(1))/diff(clim);          % Fixed bug when CAXIS used
 U = U*N;
 if N<=256
  U = uint8(U);
 else
  U = uint16(U);
 end

 % Scales data with colormap:
 U = ind2rgb(U,color_map);              % 2D to 3D RGB values [0 1]
else
 % Already is an RGB image, so do nothing.
end

 % Set mask color to color_nan:
 mn = prod(m(1:2));
 ind = find(colormask);
 U(ind)      = color_nan(1); % Red color
 U(ind+mn)   = color_nan(2); % Green color
 U(ind+mn*2) = color_nan(3); % Blue color

 % Draws the RGB image:
 h = imagesc(x,y,U,clim);

%% OUTPUTS:

% Calls to colorbarfit and freezes his colormap:
if ~isempty(cbfit_opt)
 % Creates a temporary colorbar:
 if ycolorbarfit
  hcb   = colorbarfit(cbfit_opt{:});
 else
  Nopt = min([3 length(cbfit_opt)]);
  cbfit_opt(1:Nopt) = [];
  hcb   = colorbar(cbfit_opt{:});
 end
 % Save image position:
 ha    = gca; position = get(ha,'Position'); 
 % Gets colorbar axes properties:
 ghcb  = get(hcb);
 CData = ind2rgb(get(ghcb.Children,'CData'),color_map);
 XData = get(ghcb.Children,'XData');
 YData = get(ghcb.Children,'YData');
 % Move ticks because IMAGESC draws them like centered pixels:
 XTick = ghcb.XTick;
 YTick = ghcb.YTick;
 if ~isempty(XTick)
  XTick = XTick(1:end-1) + diff(XTick(1:2))/2;
 end
 if ~isempty(YTick)
  YTick = YTick(1:end-1) + diff(YTick(1:2))/2;
 end
 % Deletes the colorbar:
 delete(hcb)            
 % Generates other colorbar:
 hcb = axes('Position',ghcb.Position);
 hcbim = imagesc(XTick,YTick,CData,'Parent',hcb); axis tight
 set(hcbim,...
  'HitTest','off',...
  'Interruptible','off',...
  'SelectionHighlight','off',...
  'Tag','TMW_COLORBAR',...
  'XData',XData,...
  'YData',YData)
 set(hcb,...
  'XAxisLocation',ghcb.XAxisLocation,...
  'YAxisLocation',ghcb.YAxisLocation,...
  'XLim',ghcb.XLim,...
  'YLim',ghcb.YLim,...
  'XDir',ghcb.XDir,...
  'YDir',ghcb.YDir,...
  'XTick',ghcb.XTick,...
  'YTick',ghcb.YTick,...
  'XTickLabel',ghcb.XTickLabel,...
  'YTickLabel',ghcb.YTickLabel,...
  'ButtonDownFcn',@resetCurrentAxes,...
  'Interruptible','off',...
  'Tag','Colorbar')
 % Returns the image position:
 axes(ha), set(ha,'Position',position)
end

% Sets output:
if ~nargout
 clear h
end