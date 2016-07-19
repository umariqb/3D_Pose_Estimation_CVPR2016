function map = bw(m)

% BW black/white colormap.
% -----------
% map = bw(m)
% -----------
% Description: black/white colormap.
% Input:       <{m}> number of entries in the colormap. By default, it
%                   equals the number of entries in the current colormap.
% Output:      {map} an {m}-by-3 colormap.

% © Liran Carmel
% Classification: Coloring and colormaps
% Last revision date: 06-Jul-2004

% check defaults
if nargin < 1
   m = size(get(gcf,'colormap'),1);
end

% initialize
map = zeros(m,3);

% fill-in the colormap
n = ceil(m/2);
map(1:n,:) = ones(n,3);