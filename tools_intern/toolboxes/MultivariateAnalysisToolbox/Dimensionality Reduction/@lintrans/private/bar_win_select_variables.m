function bar_win_select_variables(ud)

% BAR_WIN_SELECT_VARIABLES opens a window for selecting variables (bar).
% --------------------------------
% bar_win_select_variables(ud)
% --------------------------------
% Description: opens a window for selecting variables (bar).
% Input:       {ud} userdata of parent window.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 18-Jan-2005

% extract relevant parameters from {ud}
lt = ud.data;
vars = ud.variables;

% open window
name = sprintf('Select Factors (total %d)',lt.no_factors);
fig = figure('menubar','none','position',[300 300 250 400],...
    'numbertitle','off','name',name);

% define editable text
uicontrol(fig,'style','text','horizontal','left',...
    'units','normalized','position',[0.1 0.88 0.6 0.05],...
    'string','Select Factor:','background',[0.8 0.8 0.8]);
h_ed = uicontrol(fig,'style','edit',...
    'units','normalized','position',[0.73 0.88 0.1 0.05],...
    'background',[0.8 0.8 0.8],'horizontal','left',...
    'callback','loadings(lintrans,101)');

% define listbox
name_factors = samplenames(lt.factorset);
h_lb = uicontrol(fig,'style','listbox',...
    'string',name_factors,...
    'units','normalized','position',[0.1 0.12 0.8 0.75],...
    'callback','loadings(lintrans,102)');

% define OK and Cancel buttons
uicontrol(fig,'style','push','string','O.K.',...
    'units','normalized','position',[0.125 0.03 0.3 0.06],...
    'callback','loadings(lintrans,103)');
uicontrol(fig,'style','push','string','Cancel',...
    'units','normalized','position',[0.575 0.03 0.3 0.06],...
    'callback','close(gcf)');

% initialize window to previos selection
set(h_lb,'value',vars(1));
set(h_ed,'string',num2str(vars(1)));
 
% define userdata
ud = struct('data',lt,'variables',vars,'h_ed',h_ed,'h_lb',h_lb,...
    'main_fig',ud.main_fig);
set(gcf,'userdata',ud);