function update_scatter(fig)

% UPDATE_SCATTER updates the scatter(vsmatrix) figure.
% -------------------
% update_scatter(fig)
% -------------------
% Description: main drawing function of scatter(vsmatrix), updating the
%              figure each time the user changes anything.
% Input:       {fig} handle to main figure.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 09-Jun-2005

% initialization - get user data and main axes
axes(findobj(fig,'tag','ax_legend')); cla
axes(findobj(fig,'tag','ax_main')); cla
set(gca,'xlimmode','auto','ylimmode','auto');
ud = get(fig,'userdata');
vsm = ud.data;
vars = ud.variables;

% prepare data
if novariables(vsm) == 1
    data = vsm.variables(:);
    data = [data ; data];
    xlab = vsm.variables.name;
    if ~isempty(vsm.variables.units)
        xlab = sprintf('%s [%s]',xlab,vsm.variables.units);
    end
    ylab = xlab;
else
    data = vsm.variables(vars,:);
    xlab = vsm.variables(ud.variables(1)).name;
    if ~isempty(vsm.variables(ud.variables(1)).units)
        xlab = sprintf('%s [%s]',xlab,...
            vsm.variables(ud.variables(1)).units);
    end
    ylab = vsm.variables(ud.variables(2)).name;
    if ~isempty(vsm.variables(ud.variables(2)).units)
        ylab = sprintf('%s [%s]',ylab,...
            vsm.variables(ud.variables(2)).units);
    end
end

% determine legend flag
if ~ud.grp_view
    ud.leg_view = 0;
end
if ud.leg_view
    leg = [];
else
    leg = 'nolegend';
end

% determine group coloring
if ud.grp_view
    h_col = ud.h_col;
else
    h_col = [];
    leg = 'nolegend';
end

% determine group centroids
if ud.cent_view
    h_cent = ud.h_cent;
else
    h_cent = [];
end

% determine ellipse view
if ~ud.cent_view
    ud.ell_view = 0;
end
if ud.ell_view
    nop_ell = ud.nop_ell;
else
    nop_ell = 0;
end

% randomize point order, if required
gr = vsm.groupings;
if ud.randomize
    idx = randperm(nosamples(vsm));
    data = data(:,idx);
    gr = shuffle(gr,idx);
end

% call to scatter engin
if length(gr) < 2
    scatter2d_engin(fig,data,gr,h_col,h_cent,...
        ud.std_ell,nop_ell,ud.lw_ell,'o',ud.mark_size,[],xlab,ylab,leg);
else
    scatter2d_engin(fig,data,gr(ud.grp),h_col,h_cent,...
        ud.std_ell,nop_ell,ud.lw_ell,'o',ud.mark_size,[],xlab,ylab,leg);
end

% add elements to the scatter plot
axes(findobj(fig,'tag','ax_main'));

% remove edge colors, if requested
if ~ud.edges
    set(findobj(gca,'type','patch'),'markeredgecolor','none');
end

% add axes plot
if ud.ax_view
    showaxes(gca,'linewidth',ud.lw_ax,'color','k');
end

% add regression plot
ax_lims = axis;
switch ud.reg_type
    case 1
        p = ud.reg_par;
        line(data(1,:),p(1)*data(1,:)+p(2),'color','blue','linewidth',1);
    case 2
        p = ud.reg_par;
        line(data(1,:),p*data(1,:),'color','blue','linewidth',1);
end
axis(ax_lims);

% check/uncheck Options->View->Legend
h = findobj(findobj(fig,'label','&Options'),'label','Legend');
if ud.leg_view
    set(h,'check','on');
else
    set(h,'check','off');
end

% check/uncheck Options->View->Grouping
h = findobj(findobj(fig,'label','&Options'),'label','Grouping');
if ud.grp_view
    set(h,'check','on');
else
    set(h,'check','off');
end

% check/uncheck Options->Regress->submenus
h = get(findobj(findobj(fig,'label','&Options'),'label','Regress'),'children');
switch ud.reg_type
    case 0
        set(h(3),'check','on');
        set(h(1:2),'check','off');
    case 1
        set(h(2),'check','on');
        set(h([1 3]),'check','off');
    case 2
        set(h(1),'check','on');
        set(h(2:3),'check','off');
end

% update userdata
set(fig,'userdata',ud);