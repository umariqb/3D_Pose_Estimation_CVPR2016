function plot(vsm,num)

% PLOT plots variables versus samples.
% ---------
% plot(vsm)
% ---------
% Description: simple plot of samples versus variables.
% Input:       {vsm} vsmatrix instance.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 07-Mar-2006

% {num} (2nd parameter) is just a trick that allows to keep the callbacks
% function in the private directory
if nargin == 2
    plot_callbacks(num);
    return;
end

% define figure
name = sprintf('coordinate-based matrix: %s',get(vsm,'name'));
fig = figure('numbertitle','off','name',name);
samp = 1:nosamples(vsm);
vars = 1:novariables(vsm);

% define axes
ax = axes('tag','ax_main');
pos = get(gca,'position');
upp = pos(2) + pos(4); upp_space = 1 - upp;
pos = [pos(1) upp+0.1*upp_space pos(3) 0.2*upp_space];
axes('units','normalized','position',pos,'xtick',[],'ytick',[],...
    'tag','ax_grp','visible','off');

% define context-menu
cmenu = uicontextmenu('callback','plot(vsmatrix,-1)');
uimenu(cmenu,'tag','item_1');
uimenu(cmenu,'tag','item_2');
uimenu(cmenu,'tag','item_3');
set(ax,'uicontextmenu',cmenu);

% make nanless grouping
if length(vsm.groupings) == 1
    vsm.groupings = specifyunknowns(vsm.groupings);
    vsm.groupings = consistent(vsm.groupings);
else
    for ii = 1:length(vsm.groupings)
        vsm.groupings(ii) = specifyunknowns(vsm.groupings(ii));
        vsm.groupings(ii) = consistent(vsm.groupings(ii));
    end
end

% define user-data
ud = struct('data',vsm,'variables',vars,'samples',samp,...
    'var_sort',[],'grp_sort',[],'grp_view',[0 1 1],...
    'cmenu',cmenu,'rearrangement',samp,'main_fig',fig);
set(fig,'userdata',ud);

% define Options menu
men = uimenu(fig,'label','&Options','position',7);
% submenu Options->Variables
men_var = uimenu(men,'label','Variables');
uimenu(men_var,'label','Show All','check','on','callback','plot(vsmatrix,2)');
uimenu(men_var,'label','Select...','callback','plot(vsmatrix,3)');
% submenu Options->Samples
men_sam = uimenu(men,'label','Samples');
uimenu(men_sam,'label','Show All','check','on','callback','plot(vsmatrix,4)');
uimenu(men_sam,'label','Select...','callback','plot(vsmatrix,5)');
% submenu Options->Sorting
men_sor = uimenu(men,'label','Sort by','separator','on');
uimenu(men_sor,'label','Variable...','callback','plot(vsmatrix,6)');
h = uimenu(men_sor,'label','Group...','callback','plot(vsmatrix,7)');
if isempty(vsm.groupings)
    set(h,'enable','off');
end
uimenu(men_sor,'label','Nothing','check','on','callback','plot(vsmatrix,8)');
% submenu View->Grouping
h = uimenu(men,'label','View Grouping','separator','on','callback','plot(vsmatrix,9)');
h1 = uimenu(men,'label','View Options...','callback','plot(vsmatrix,10)');
if isempty(vsm.groupings)
    set([h h1],'enable','off');
end

% plot the data
plot_callbacks(1)