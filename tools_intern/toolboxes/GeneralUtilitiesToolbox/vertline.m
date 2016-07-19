function h_line = vertline(x_coord)

% VERTLINE draws black vertical line on current axes.
% --------------------------
% h_line = vertline(x_coord)
% --------------------------
% Description: draws black vertical line on current axes at a certain
%              x-coordinate.
% Input:       {x_coord} desired x-coordinate.
% Output:      {h_line} handle to line.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 05-Jan-2005

h_line = line([x_coord x_coord],get(gca,'ylim'),'color','k');