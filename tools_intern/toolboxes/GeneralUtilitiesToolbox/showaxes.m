function showaxes(varargin)

% SHOWAXES draws the two axes in solid black line.
% ------------------------------------------------
% showaxes(ax, property_name, property_value, ...)
% ------------------------------------------------
% Description: draws the two axes in solid black line.
% Input:       <{ax}> handle to axes (def=gca).
%              <{property_name, property_value}> are LINE (core MATLAB)
%                   properties.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 16-Mar-2006

% parse input line
if isempty(varargin)         % showaxes
    ax = gca;
    varargin = {'color','k'};
elseif ishandle(varargin{1}) % showaxes(ax, ...)
    ax = varargin{1};
    varargin(1) = [];
else                         % showaxes(property_name, property_value, ...)
    ax = gca;
end

% plot the lines
axes(ax);
line([0 0],get(ax,'ylim'),varargin{:});
line(get(ax,'xlim'),[0 0],varargin{:});