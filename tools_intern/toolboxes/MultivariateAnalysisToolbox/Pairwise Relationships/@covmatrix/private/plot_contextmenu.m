function plot_contextmenu(ud)

% PLOT_CONTEXTMENU callback for the plot contextmenu.
% --------------------
% plot_contextmenu(ud)
% --------------------
% Description: callback for the plot contextmenu.
% Input:       {ud} userdata of parent window.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 27-Sep-2004

% extract relevant information from userdata structure
cmenu = ud.cmenu;
cvm = ud.data;

% find mouse location
location = get(gca,'currentpoint');
location = location(1,1:2);

% find the closest row and column variable
row_var = max(min(floor(location(1)),get(cvm,'no_cols')),1);
col_var = max(min(floor(location(2)),get(cvm,'no_rows')),1);

% first contextmenu item
row_names = samplenames(get(cvm,'row_sampleset'));
col_names = samplenames(get(cvm,'col_sampleset'));
str = sprintf('%s / %s',upper(row_names{row_var}),...
    upper(col_names{col_var}));
h = findobj(cmenu,'tag','item_1');
set(h,'label',str);

% second contextmenu item
str = sprintf('Number of samples: %d',cvm.no_samples(row_var,col_var));
h = findobj(cmenu,'tag','item_2');
set(h,'label',str);

% third contextmenu item
matrix = get(cvm,'matrix');
str = sprintf('r = %.2f',matrix(row_var,col_var));
h = findobj(cmenu,'tag','item_3');
set(h,'label',str);

% fourth contextmenu item
if ud.test_idx(1)
    p_value = cvm.p_value{ud.test_idx(1)};
    str = sprintf('P = %.2e',p_value(row_var,col_var));
    h = findobj(cmenu,'tag','item_4');
    set(h,'label',str);
end

% fifth contextmenu item
if ud.ci_view
    str = sprintf('CI = [%.2f %.2f] @ %.2f%%',ud.low(row_var,col_var),...
        ud.up(row_var,col_var),100*ud.ci_level);
    h = findobj(cmenu,'tag','item_5');
    set(h,'label',str);
end