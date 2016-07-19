function col_rgb = real2rgb(col_real)

% REAL2RGB turns a real representation of colors into RGB.
% --------------------------
% str_blanked = reblank(str)
% --------------------------
% Description: turns a real representation of colors (i.e., each color is
%              represented by a number in the range [0,1]) into their RGB
%              values, according to the current colormap.
% Input:       {col_real} color(s) in real representation.
% Output:      {col_rgb} color(s) in RGB representation.

% © Liran Carmel
% Classification: Coloring and colormaps
% Last revision date: 24-Feb-2004

% get current colormap and its resolution
map = colormap;
len = size(map,1);

% map [0,1] -> [1,2, ..., len]
col_real = col_real(:);
idx = round((len-1)*col_real+1);
col_rgb = map(idx,:);