function scatter_callbacks(num)

% SCATTER_CALLBACKS activate the callbacks of SCATTER.
% ----------------------
% scatter_callbacks(num)
% ----------------------
% Description: activate the callbacks of SCATTER.
% Input:       {num} identify the callback.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 10-Jan-2005

% find main figure and axes
ud = get(gcf,'userdata');
fig = ud.main_fig;

switch num
    case -1 % context menu
        scatter_contextmenu(ud);
    case 1  % update plot
        update_scatter(fig);
    case 2  % Options->Variables
        scatter_win_select_variables(ud);
    case 3  % Options->View->Legend
        h = findobj(findobj(fig,'label','&Options'),'label','Legend');
        if strcmp(get(h,'check'),'on')
            ud.leg_view = 0;
        else
            ud.leg_view = 1;
        end
        set(fig,'userdata',ud);
        update_scatter(fig);
    case 4  % Options->View->Grouping
        h = findobj(findobj(fig,'label','&Options'),'label','Grouping');
        if strcmp(get(h(1),'check'),'on')
            ud.grp_view = 0;
        else
            ud.grp_view = 1;
        end
        set(fig,'userdata',ud);
        update_scatter(fig);
    case 5  % Options->View->Settings
        scatter_win_view_settings(ud);
    case 6  % Options->Grouping
        scatter_win_view_grouping(ud);
    case 7  % Options->Regress->None
        ud.reg_type = 0;
        set(fig,'userdata',ud);
        update_scatter(fig);
    case 8  % Options->Regress->Intercept
        h = get(findobj(findobj(fig,'label','&Options'),'label','Regress'),'children');
        data = ud.data.variables(ud.variables,:);
        ud.reg_par = regress1d(data(1,:),data(2,:),'intercept');
        ud.reg_type = 1;
        set(h(2),'label',sprintf('Intercept (y = %.2f x + %.2f)',ud.reg_par(1),...
            ud.reg_par(2)));
        set(fig,'userdata',ud);
        update_scatter(fig);
    case 9  % Options->Regress->Slope
        h = get(findobj(findobj(fig,'label','&Options'),'label','Regress'),'children');
        data = ud.data.variables(ud.variables,:);
        ud.reg_par = regress1d(data(1,:),data(2,:),'slope');
        ud.reg_type = 2;
        set(h(1),'label',sprintf('Slope (y = %.2f x)',ud.reg_par));
        set(fig,'userdata',ud);
        update_scatter(fig);
    case 101    % scatter_win_select_variables: x-axis variable
        set(ud.h_lb(1),'value',str2num(get(ud.h_ed(1),'string')));
    case 102    % scatter_win_select_variables: y-axis variable
        set(ud.h_lb(2),'value',str2num(get(ud.h_ed(2),'string')));
    case 103    % scatter_win_select_variables: x-axis listbox
        set(ud.h_ed(1),'string',num2str(get(ud.h_lb(1),'value')));
    case 104    % scatter_win_select_variables: y-axis listbox
        set(ud.h_ed(2),'string',num2str(get(ud.h_lb(2),'value')));
    case 105    % scatter_win_select_variables: OK
        this_fig = gcf;
        vars(1) = get(ud.h_lb(1),'value');
        vars(2) = get(ud.h_lb(2),'value');
        ud = get(fig,'userdata');
        h = get(findobj(fig,'label','Regress'),'children');
        set(h(2),'label','Intercept (y = ax + b)');
        set(h(1),'label','Slope (y = ax)');
        ud.reg_type = 0;
        ud.variables = vars;
        set(fig,'userdata',ud);
        update_scatter(fig);
        close(this_fig)
    case 201    % scatter_win_view_grouping: listbox
        grp = get(ud.h_lb,'value');
        fud = get(fig,'userdata');
        vsm = fud.data;
        set(ud.h_txt,'string',sprintf('(of %d)',...
            vsm.groupings(grp).no_hierarchies));
    case 202    % scatter_win_view_grouping: O.K
        this_fig = gcf;
        fud = get(fig,'userdata');
        fud.grp = get(ud.h_lb,'value');
        fud.h_col = str2num(get(ud.h_ed(1),'string'));
        fud.h_cent = str2num(get(ud.h_ed(2),'string'));
        set(fig,'userdata',fud);
        update_scatter(fig);
        close(this_fig)
    case 301    % scatter_win_view_settings: view grouping checkbox
        if get(ud.h_ch(1),'value')
            set(ud.h_ch(2),'enable','on');
        else
            set(ud.h_ch(2),'enable','off','value',0);
        end
    case 302    % scatter_win_view_settings: view centroids checkbox
        if get(ud.h_ch(3),'value')
            set(ud.h_ch(4),'enable','on');
            set(ud.h_txt(1:4),'enable','on');
            set(ud.h_ed(2:5),'enable','on');
        else
            set(ud.h_ch(4),'enable','off','value',0);
            set(ud.h_txt(1:4),'enable','off');
            set(ud.h_ed(2:5),'enable','off');
        end
    case 303    % scatter_win_view_settings: view ellipses checkbox
        if get(ud.h_ch(4),'value')
            set(ud.h_txt(2:4),'enable','on');
            set(ud.h_ed(3:5),'enable','on');
        else
            set(ud.h_txt(2:4),'enable','off');
            set(ud.h_ed(3:5),'enable','off');
        end
    case 304    % scatter_win_view_settings: view axes checkbox
        if get(ud.h_ch(5),'value')
            set(ud.h_txt(5),'enable','on');
            set(ud.h_ed(6),'enable','on');
        else
            set(ud.h_txt(5),'enable','off');
            set(ud.h_ed(6),'enable','off');
        end
    case 305    % scatter_win_view_settings: O.K.
        this_fig = gcf;
        fud = get(fig,'userdata');
        fud.mark_size(1) = str2num(get(ud.h_ed(1),'string'));
        fud.grp_view = get(ud.h_ch(1),'value');
        fud.leg_view = get(ud.h_ch(2),'value');
        fud.cent_view = get(ud.h_ch(3),'value');
        fud.mark_size(2) = str2num(get(ud.h_ed(2),'string'));
        fud.ell_view = get(ud.h_ch(4),'value');
        fud.std_ell = str2num(get(ud.h_ed(3),'string'));
        fud.nop_ell = str2num(get(ud.h_ed(4),'string'));
        fud.lw_ell = str2num(get(ud.h_ed(5),'string'));
        fud.ax_view = get(ud.h_ch(5),'value');
        fud.lw_ax = str2num(get(ud.h_ed(6),'string'));
        fud.edges = get(ud.h_ch(6),'value');
        fud.randomize = get(ud.h_ch(7),'value');
        set(fig,'userdata',fud);
        update_scatter(fig);
        close(this_fig)
end