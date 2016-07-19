function h_line = horizline(y_coord)

% HORIZLINE draws black horizontal line on current axes.
% ---------------------------
% h_line = horizline(y_coord)
% ---------------------------
% Description: draws black horizontal line on current axes at a certain
%              y-coordinate.
% Input:       {y_coord} desired y-coordinate.
% Output:      {h_line} handle to line.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 05-Jan-2005

h_line = line(get(gca,'xlim'),[y_coord y_coord],'color','k');