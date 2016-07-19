function update_scatter(fig)

% UPDATE_SCATTER updates the scatter view of the loadings plot of LINTRANS.
% -------------------
% update_scatter(fig)
% -------------------
% Description: main drawing function of the scatter view of the loading
%              plot of LINTRANS, updating the figure each time the user
%              changes anything.
% Input:       {fig} handle to main figure.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 14-Jul-2005

% initialization - get user data and main axes
axes(findobj(fig,'tag','ax_legend')); cla
axes(findobj(fig,'tag','ax_main')); cla
set(gca,'xlimmode','auto','ylimmode','auto','xtickmode','auto',...
    'climmode','auto');
ud = get(fig,'userdata');
lt = ud.data;
vars = ud.variables;

% prepare data
data = lt.U(:,vars).';
names = samplenames(lt.factorset);
if lt.no_factors == 1
    xlab = lt.scores.variables.name;
    ylab = xlab;
else
    xlab = names{ud.variables(1)};
    ylab = names{ud.variables(2)};
end

% determine legend flag and group coloring
if ud.leg_view
    leg = [];
else
    leg = 'nolegend';
end

% call to scatter engin
scatter2d_engin(fig,data,ud.grouping,1,[],0,0,0,'o',...
    ud.mark_size,[],xlab,ylab,leg);

% add elements to the scatter plot
axes(findobj(fig,'tag','ax_main'));

% add axes plot
if ud.ax_view
    showaxes(gca,'linewidth',ud.lw_ax,'color','k');
end

% check/uncheck Options->Scatter plot and Options->Bar plot
h = findobj(fig,'label','Scatter plot');
set(h,'check','on');
h = findobj(fig,'label','Bar plot');
set(h,'check','off');

% check/uncheck Options->View->Legend
h = findobj(fig,'label','Legend');
set(h,'enable','on');
if ud.leg_view
    set(h,'check','on');
else
    set(h,'check','off');
end

% update userdata
set(fig,'userdata',ud);