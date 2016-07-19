function plot_contextmenu(ud)

% PLOT_CONTEXTMENU callback for the plot contextmenu.
% --------------------
% plot_contextmenu(ud)
% --------------------
% Description: callback for the plot contextmenu.
% Input:       {ud} userdata of parent window.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 02-Apr-2004

% extract relevant information from userdata structure
cmenu = ud.cmenu;
ssm = ud.data;

% find mouse location
location = get(gca,'currentpoint');
location = location(1,1:2);

% find the closest row and column variable
row_samp = max(min(floor(location(1)),get(ssm,'no_cols')),1);
col_samp = max(min(floor(location(2)),get(ssm,'no_rows')),1);

% first contextmenu item
row_names = get(ssm,'rows_samples');
col_names = get(ssm,'cols_samples');
str = sprintf('%s / %s',upper(row_names{row_samp}),...
    upper(col_names{col_samp}));
h = findobj(cmenu,'tag','item_1');
set(h,'label',str);

% second contextmenu item
matrix = get(ssm,'matrix');
str = sprintf('w = %.2f',matrix(row_samp,col_samp));
h = findobj(cmenu,'tag','item_2');
set(h,'label',str);