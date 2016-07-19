function loadings_callbacks(num)

% LOADINGS_CALLBACKS lists the callback functions of LOADINGS.
% -----------------------
% loadings_callbacks(num)
% -----------------------
% Description: lists the callback functions of LOADINGS.
% Input:       {num} each number defines a different callback.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 10-Jan-2005

% find main figure and axes
ud = get(gcf,'userdata');
fig = ud.main_fig;

% take care of 
switch num
    case -1 % context menu
        scatter_contextmenu(ud);
    case 2  % Options->Scatter plot
        ud.sc_view = 1;
        set(fig,'userdata',ud);
        update_scatter(fig);
    case 3  % Options->Bar plot
        ud.sc_view = 0;
        set(fig,'userdata',ud);
        update_bar(fig);
    case 5  % Options->View->Legend
        h = findobj(fig,'label','Legend');
        if strcmp(get(h,'check'),'on')
            ud.leg_view = 0;
        else
            ud.leg_view = 1;
        end
        set(fig,'userdata',ud);
        loadings_callbacks(1);
    otherwise  % internal redirection
        fud = get(fig,'userdata');
        if fud.sc_view
            scatter_callbacks(num);
        else
            bar_callbacks(num);
        end
end