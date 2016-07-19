function scatter_callbacks(num)

% SCATTER_CALLBACKS lists the callback functions of LOADINGS/SCATTER.
% ----------------------
% scatter_callbacks(num)
% ----------------------
% Description: lists the callback functions of LOADINGS/SCATTER.
% Input:       {num} each number defines a different callback.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 18-Jan-2005

% find main figure and axes
ud = get(gcf,'userdata');
fig = ud.main_fig;

switch num
    case -1 % context menu
        scatter_contextmenu(ud);
    case 1  % update plot
        update_scatter(fig);
    case 4  % Options->Factors
        scatter_win_select_variables(ud);
    case 5  % Options->View->Legend
        h = findobj(fig,'label','Legend');
        if strcmp(get(h,'check'),'on')
            ud.leg_view = 0;
        else
            ud.leg_view = 1;
        end
        set(fig,'userdata',ud);
        scatter_cb(1);
    case 6  % Options->View->Settings
        scatter_win_view_settings(ud);
    case 101    % scatter_win_select_variables: editbox x-variable
        set(ud.h_lb(1),'value',str2num(get(ud.h_ed(1),'string')));
    case 102    % scatter_win_select_variables: editbox y-variable
        set(ud.h_lb(2),'value',str2num(get(ud.h_ed(2),'string')));
    case 103    % scatter_win_select_variables: listbox x-variable
        set(ud.h_ed(1),'string',num2str(get(ud.h_lb(1),'value')));
    case 104    % scatter_win_select_variables: listbox y-variable
        set(ud.h_ed(2),'string',num2str(get(ud.h_lb(2),'value')));
    case 105    % scatter_win_select_variables: O.K.
        this_fig = gcf;
        vars(1) = get(ud.h_lb(1),'value');
        vars(2) = get(ud.h_lb(2),'value');
        fud = get(fig,'userdata');
        fud.variables = vars;
        set(fig,'userdata',fud);
        update_scatter(fig);
        close(this_fig)
    case 201    % scatter_win_view_settings: view axes
        if get(ud.h_ch(2),'value')
            set(ud.h_txt,'enable','on');
            set(ud.h_ed(2),'enable','on');
        else
            set(ud.h_txt,'enable','off');
            set(ud.h_ed(2),'enable','off');
        end
    case 202    % scatter_win_view_settings: O.K.
        this_fig = gcf;
        fud = get(fig,'userdata');
        fud.mark_size = str2num(get(ud.h_ed(1),'string'));
        fud.leg_view = get(ud.h_ch(1),'value');
        fud.ax_view = get(ud.h_ch(2),'value');
        fud.lw_ax = str2num(get(ud.h_ed(2),'string'));
        set(fig,'userdata',fud);
        update_scatter(fig);
        close(this_fig)
end