function scatter_win_view_settings(ud)

% SCATTER_WIN_VIEW_SETTINGS opens a window for selecting view settings (scatter).
% -----------------------------
% scatter_win_view_settings(ud)
% -----------------------------
% Description: opens a window for selecting view settings (scatter).
% Input:       {ud} userdata of parent window.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 10-Jan-2005

% open window
fig = figure('menubar','none','position',[300 300 200 200],...
    'numbertitle','off','name','View Settings');

% define editable text
delta = 1/8;
yy = 1 - delta;
height = 0.8*delta;
uicontrol(fig,'style','text','horizontal','left',...
    'units','normalized','position',[0.05 yy 0.9 height],...
    'string','View Data','background',[0.8 0.8 0.8]);
yy = yy - delta;
uicontrol(fig,'style','text','string','marker size:',...
    'units','normalized','position',[0.15 yy 0.6 height],...
    'background',[0.8 0.8 0.8],'horizontal','left');
h_ed(1) = uicontrol(fig,'style','edit','string',num2str(64),...
    'units','normalized','position',[0.75 yy 0.2 height],...
    'background',[0.8 0.8 0.8],'horizontal','left');
yy = yy - delta;
h_ch(1) = uicontrol(fig,'style','check','horizontal','left',...
    'units','normalized','position',[0.05 yy 0.9 height],...
    'string','View Legend','background',[0.8 0.8 0.8]);
yy = yy - delta;
h_ch(2) = uicontrol(fig,'style','check','horizontal','left',...
    'units','normalized','position',[0.05 yy 0.9 height],...
    'string','View Axes','background',[0.8 0.8 0.8],...
    'callback','loadings(lintrans,201)');
yy = yy - delta;
h_txt = uicontrol(fig,'style','text','string','line width:',...
    'units','normalized','position',[0.15 yy 0.6 height],...
    'background',[0.8 0.8 0.8],'horizontal','left');
h_ed(2) = uicontrol(fig,'style','edit','string',num2str(1),...
    'units','normalized','position',[0.75 yy 0.2 height],...
    'background',[0.8 0.8 0.8],'horizontal','left');

% define OK and Cancel buttons
uicontrol(fig,'style','push','string','O.K.',...
    'units','normalized','position',[0.125 0.5*delta 0.3 1.5*height],...
    'callback','loadings(lintrans,202)');
uicontrol(fig,'style','push','string','Cancel',...
    'units','normalized','position',[0.575 0.5*delta 0.3 1.5*height],...
    'callback','close(gcf)');

% initialize window to previos selection
set(h_ed(1),'string',num2str(ud.mark_size(1)));
set(h_ch(1),'value',ud.leg_view);
set(h_ch(2),'value',ud.ax_view);
if ~ud.ax_view
    set(h_ed(2),'enable','off');
    set(h_txt,'enable','off');
end
set(h_ed(2),'string',num2str(ud.lw_ax));
 
% define userdata
ud = struct('h_ed',h_ed,'h_ch',h_ch,'h_txt',h_txt,'main_fig',ud.main_fig);
set(gcf,'userdata',ud);