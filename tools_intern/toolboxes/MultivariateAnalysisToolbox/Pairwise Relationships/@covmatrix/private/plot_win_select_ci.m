function plot_win_select_ci(ud)

% PLOT_WIN_SELECT_CI chooses a confidence interval.
% ---------------------------
% plot_win_sort_variables(ud)
% ---------------------------
% Description: chooses and computes a confidence interval.
% Input:       {ud} userdata of parent window.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 10-Jan-2005

% available confidence interval
ci = 'symmetric z-statistic';

% open window
fig = figure('menubar','none','position',[300 300 250 350],...
    'numbertitle','off','name','Choose Confidence Interval');

% define editable line
uicontrol(fig,'style','text','string','confidence level [0,1]:',...
    'units','normalized','position',[0.05 0.9 0.45 0.05],...
    'background',[0.8 0.8 0.8],'horizontal','left');
h_ed = uicontrol(fig,'style','edit',...
    'units','normalized','position',[0.5 0.9 0.2 0.05],...
    'background',[0.8 0.8 0.8],'horizontal','left');

% define listbox
uicontrol(fig,'style','text','string','available interval types:',...
    'units','normalized','position',[0.05 0.76 0.5 0.05],...
    'background',[0.8 0.8 0.8],'horizontal','left');
h_lb = uicontrol(fig,'style','listbox','string',ci,...
    'units','normalized','position',[0.05 0.12 0.9 0.64]);

% define OK and Cancel buttons
uicontrol(fig,'style','push','string','O.K.',...
    'units','normalized','position',[0.125 0.02 0.3 0.07],...
    'callback','plot(covmatrix,201)');
uicontrol(fig,'style','push','string','Cancel',...
    'units','normalized','position',[0.575 0.02 0.3 0.07],...
    'callback','close(gcf)');

% initialize window to previos selection
set(h_ed,'string',num2str(ud.ci_level));
if ud.ci_view
    set(h_lb,'value',ud.ci_view);
end

% define userdata
ud = struct('main_fig',ud.main_fig,'h_ed',h_ed,'h_lb',h_lb,'available_ci',ci);
set(gcf,'userdata',ud);