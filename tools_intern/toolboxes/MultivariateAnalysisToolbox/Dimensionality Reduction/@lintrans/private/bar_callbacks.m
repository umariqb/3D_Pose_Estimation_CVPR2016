function bar_callbacks(num)

% BAR_CALLBACKS lists the callback functions of LOADINGS/BAR.
% ------------------
% bar_callbacks(num)
% ------------------
% Description: lists the callback functions of LOADINGS/BAR.
% Input:       {num} each number defines a different callback.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 18-Jan-2005

% find main figure and axes
ud = get(gcf,'userdata');
fig = ud.main_fig;

switch num
    case -1 % context menu
        bar_contextmenu(ud);
    case 1  % update plot
        update_bar(fig);
    case 4  % Options->Factors
        bar_win_select_variables(ud);
    case 6  % Options->View->Settings
        bar_win_view_settings(ud);
    case 101    % bar_win_select_variables: editbox
        set(ud.h_lb,'value',str2num(get(ud.h_ed,'string')));
    case 102    % bar_win_select_variables: listbox
        set(ud.h_ed,'string',num2str(get(ud.h_lb,'value')));
    case 103    % bar_win_select_variables: O.K.
        this_fig = gcf;
        fud = get(fig,'userdata');
        fud.variables(1) = get(ud.h_lb,'value');
        set(fig,'userdata',fud);
        update_bar(fig);
        close(this_fig)
    case 201    % bar_win_view_settings: O.K.
        this_fig = gcf;
        fud = get(fig,'userdata');
        fud.bar_width = str2num(get(ud.h_ed(1),'string'));
        fud.lw_ax = str2num(get(ud.h_ed(2),'string'));
        set(fig,'userdata',fud);
        update_bar(fig);
        close(this_fig)
end