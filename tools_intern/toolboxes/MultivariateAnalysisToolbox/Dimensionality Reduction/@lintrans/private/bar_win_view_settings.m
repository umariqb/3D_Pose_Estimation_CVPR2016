function bar_win_view_settings(ud)

% BAR_WIN_VIEW_SETTINGS opens a window for selecting view settings (scatter).
% -------------------------
% bar_win_view_settings(ud)
% -------------------------
% Description: opens a window for selecting view settings (scatter).
% Input:       {ud} userdata of parent window.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 10-Jan-2005

% open window
fig = figure('menubar','none','position',[300 300 200 100],...
    'numbertitle','off','name','View Settings');

% define editable text
delta = 1/4;
yy = 1 - delta;
height = 0.8*delta;
uicontrol(fig,'style','text','string','bar width:',...
    'units','normalized','position',[0.05 yy 0.6 height],...
    'background',[0.8 0.8 0.8],'horizontal','left');
h_ed(1) = uicontrol(fig,'style','edit','string',num2str(0.9),...
    'units','normalized','position',[0.75 yy 0.2 height],...
    'background',[0.8 0.8 0.8],'horizontal','left');
yy = yy - delta;
uicontrol(fig,'style','text','string','x-axis width:',...
    'units','normalized','position',[0.05 yy 0.6 height],...
    'background',[0.8 0.8 0.8],'horizontal','left');
h_ed(2) = uicontrol(fig,'style','edit','string',num2str(1.5),...
    'units','normalized','position',[0.75 yy 0.2 height],...
    'background',[0.8 0.8 0.8],'horizontal','left');

% define OK and Cancel buttons
uicontrol(fig,'style','push','string','O.K.',...
    'units','normalized','position',[0.125 0.5*delta 0.3 1.5*height],...
    'callback','loadings(lintrans,201)');
uicontrol(fig,'style','push','string','Cancel',...
    'units','normalized','position',[0.575 0.5*delta 0.3 1.5*height],...
    'callback','close(gcf)');

% initialize window to previos selection
set(h_ed(1),'string',num2str(ud.bar_width));
set(h_ed(2),'string',num2str(ud.lw_ax));
 
% define userdata
ud = struct('h_ed',h_ed,'main_fig',ud.main_fig);
set(gcf,'userdata',ud);