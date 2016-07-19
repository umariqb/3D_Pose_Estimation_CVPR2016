function loadings(lt,num)

% LOADINGS plots the loadings of the linear transformation.
% ------------
% loadings(lt)
% ------------
% Description: plots the loadings of the linear transformation.
% Input:       {lt} lintrans instance.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 18-Jan-2005

% {num} (2nd parameter) is just a trick that allows to keep the callbacks
% function in the private directory
if nargin == 2
    loadings_callbacks(num);
    return;
end

% define figure
name = sprintf('%s loadings plot',lt.type);
fig = figure('numbertitle','off','name',name);

% define axes
ax = subplot('position',[0.73 0.1 0.25 0.8]);
set(ax,'tag','ax_legend');
ax = subplot('position',[0.1 0.1 0.58 0.8]);
set(ax,'tag','ax_main');

% define contextmenu
cmenu = uicontextmenu('callback','loadings(lintrans,-1)');
uimenu(cmenu,'tag','item_1');
uimenu(cmenu,'tag','item_2');
set(ax,'uicontextmenu',cmenu);

% by default, use SCATTER plot for more than one new variables and BAR for
% one new variable
if nofactors(lt) == 1
    vars = [1 1];
    sc_view = false;
else
    vars = [1 2];
    sc_view = true;
end

% prepare grouping
no_vars = novariables(lt);
name_vars = samplenames(lt.variableset);
gr = grouping(1:no_vars,name_vars);

% prepare x-axis variable names for display later in BAR view
var_text_horiz = [];
var_loc_horiz = [];
no_lines_horiz = zeros(1,no_vars);
WIDTH_MAX = 0.9;
DELTA = 0.1;
for ii = 1:no_vars
    str = disptext(name_vars{ii},9);
    n = size(str,1);
    width = DELTA*(n-1);
    if width > WIDTH_MAX
        delta = WIDTH_MAX / (n-1);
        width = WIDTH_MAX;
    else
        delta = DELTA;
    end
    var_text_horiz = strvcat(var_text_horiz,str);   %#ok
    var_loc_horiz = [var_loc_horiz ii+width-2*delta*((1:n)-1)];
    no_lines_horiz(ii) = n;
end

% define user-data
ud = struct('data',lt,'variables',vars,'cmenu',cmenu,'main_fig',fig,...
    'leg_view',1,'mark_size',64,'ax_view',1,'lw_ax',1,'grouping',gr,...
    'sc_view',sc_view,'txt_horiz',var_text_horiz,'loc_horiz',var_loc_horiz,...
    'nl_horiz',no_lines_horiz,'bar_width',0.9);
set(fig,'userdata',ud);

% define Options menu
men = uimenu(fig,'label','&Options','position',7);
% submenu Options->Scatter plot
uimenu(men,'label','Scatter plot','callback','loadings(lintrans,2)');
% submenu Options->Bar plot
uimenu(men,'label','Bar plot','callback','loadings(lintrans,3)');
% submenu Options->Factors
uimenu(men,'label','Factors...','separator','on',...
    'callback','loadings(lintrans,4)');
% submenu Options->View Options
men_view = uimenu(men,'label','View Options');
uimenu(men_view,'label','Legend','check','on','callback','loadings(lintrans,5)');
uimenu(men_view,'label','Settings...','callback','loadings(lintrans,6)');

% plot the data
loadings_callbacks(1)