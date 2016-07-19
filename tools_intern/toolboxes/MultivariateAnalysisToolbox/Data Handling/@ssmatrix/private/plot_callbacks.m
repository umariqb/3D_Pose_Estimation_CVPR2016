function plot_callbacks(num)

% PLOT_CALLBACKS lists the callback functions of PLOT.
% -------------------
% plot_callbacks(num)
% -------------------
% Description: lists the callback functions of PLOT.
% Input:       {num} each number defines a different callback

% © Liran Carmel
% Classification: Visualization
% Last revision date: 10-Jan-2005

% find main figure and axes
ud = get(gcf,'userdata');
fig = ud.main_fig;

switch num
    case -1 % context menu
        plot_contextmenu(ud)
    case 1  % update plot
        update_plot(fig);
    case 2  % Options->View->Color coding
        h = gcbo;
        h_other = findobj(fig,'label','Thresholding');
        set(h,'check','on');
        set(h_other,'check','off');
        ud.th_view = 0;
        set(fig,'userdata',ud);
        plot_cb(1);
    case 3  % Options->View->Thresholding
        h = gcbo;
        h_other = findobj(fig,'label','Color coding');
        set(h,'check','on');
        set(h_other,'check','off');
        ud.th_view = 1;
        set(fig,'userdata',ud);
        plot_cb(1)
    case 101    % update_plot: slider
        h_sl = gco;
        fig = get(h_sl,'parent');
        h_ed = findobj(fig,'type','uicontrol');
        h_ed = findobj(h_ed,'style','edit');
        val = get(h_sl,'value');
        set(h_ed,'string',sprintf('%.2e',val));
        ax = findobj(fig,'type','axes');
        ud = get(fig,'userdata');
        h_sur = findobj(ax,'type','surface');
        thresh = get(ud.data,'matrix');
        thresh = (thresh < val);
        set(h_sur,'cdata',double(thresh));
        ud.th_val = val;
        set(fig,'userdata',ud);
    case 102    % update_plot: editbox
        h_ed = gco;
        fig = get(h_ed,'parent');
        h_sl = findobj(fig,'type','uicontrol');
        h_sl = findobj(h_sl,'style','slider');
        val = str2num(get(h_ed,'string'));
        mn = get(h_sl,'min');
        mx = get(h_sl,'max');
        if val < mn
            val = mn;
            set(h_ed,'string',num2str(val));
        elseif val > mx
            val = mx;
            set(h_ed,'string',num2str(val));
        end
        set(h_sl,'value',val);
        ax = findobj(fig,'type','axes');
        ud = get(fig,'userdata');
        h_sur = findobj(ax,'type','surface');
        thresh = get(ud.data,'matrix');
        thresh = (thresh < val);
        set(h_sur,'cdata',double(thresh));
        ud.th_val = val;
        set(fig,'userdata',ud);
end