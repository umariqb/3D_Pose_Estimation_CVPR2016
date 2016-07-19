function plot_win_sort_grouping(ud)

% PLOT_WIN_SORT_GROUPING chooses a group that underlies sorting.
% --------------------------
% plot_win_sort_grouping(ud)
% --------------------------
% Description: chooses a grouping that underlies sorting.
% Input:       {ud} userdata of parent window.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 10-Jan-2005

% extract relevant parameters from {ud}
vsm = ud.data;
grp_sort = ud.grp_sort;

% open window
fig = figure('menubar','none','position',[300 300 250 350],...
    'numbertitle','off','name','Choose a Group and Hierarchy to Sort Upon');

% choose group listbox
uicontrol(fig,'style','text','string','Choose Group:',...
    'units','normalized','position',[0.05 0.9 0.3 0.05],...
    'background',[0.8 0.8 0.8],'horizontal','left');
list = [];
for ii = 1:length(vsm.groupings)
    list = [list {vsm.groupings(ii).name}];
end
h_lb = uicontrol(fig,'style','listbox','string',list,...
    'units','normalized','position',[0.05 0.22 0.9 0.68],...
    'callback','plot(vsmatrix,301)');

% choose hierarchy
uicontrol(fig,'style','text','string','Hierarchy level:',...
    'units','normalized','position',[0.05 0.14 0.31 0.05],...
    'background',[0.8 0.8 0.8],'horizontal','left');
h_ed = uicontrol(fig,'style','edit','string',1,...
    'units','normalized','position',[0.36 0.14 0.2 0.05],...
    'background',[0.8 0.8 0.8],'horizontal','left');
h_txt = uicontrol(fig,'style','text',...
    'string',sprintf('(of %d)',vsm.groupings(1).no_hierarchies),...
    'units','normalized','position',[0.6 0.14 0.22 0.05],...
    'background',[0.8 0.8 0.8],'horizontal','left');

% define OK and Cancel buttons
uicontrol(fig,'style','push','string','O.K.',...
    'units','normalized','position',[0.125 0.02 0.3 0.07],...
    'callback','plot(vsmatrix,302)');
uicontrol(fig,'style','push','string','Cancel',...
    'units','normalized','position',[0.575 0.02 0.3 0.07],...
    'callback','close(gcf)');

% initialize window to previos selection
if ~isempty(grp_sort)
   set(h_lb,'value',grp_sort(1));
   set(h_ed,'string',num2str(grp_sort(2)));
end

% define userdata
ud = struct('main_fig',ud.main_fig,'h_ed',h_ed,'h_lb',h_lb,'h_txt',h_txt);
set(gcf,'userdata',ud);