function plot_callbacks(num)

% PLOT_CALLBACKS lists the callback functions of PLOT.
% -------------------
% plot_callbacks(num)
% -------------------
% Description: lists the callback functions of PLOT.
% Input:       {num} each number defines a different callback

% © Liran Carmel
% Classification: Visualization
% Last revision date: 02-Mar-2006

% find main figure and axes
ud = get(gcf,'userdata');
fig = ud.main_fig;

switch num
    case -1 % context menu
        plot_contextmenu(ud)
    case 1  % update plot
        update_plot(fig);
    case 2  % Options->Hypothesis Testing->None
        h = gcbo;
        h_other = get(findobj(fig,'label','Hypothesis Testing'),'children');
        h_other(h_other == h) = [];
        set(h,'check','on');
        set(h_other,'check','off');
        ud.th_view = 0;
        set(fig,'userdata',ud);
        plot_callbacks(1);
    case 3  % Options->Hypothesis Testing->Hypotheses
        h = gcbo;
        h_other = get(findobj(fig,'label','Hypothesis Testing'),'children');
        h_other(h_other == h) = [];
        set(h,'check','on');
        set(h_other,'check','off');
        ud.th_view = 1;
        ud.test_idx = str2num(get(h,'tag'));
        set(fig,'userdata',ud);
        plot_callbacks(1)
    case 4  % Options->Confidence Interval
        plot_win_select_ci(ud);
    case 101    % update_plot: slider
        h_sl = gco;
        fig = get(h_sl,'parent');
        h_ed = findobj(fig,'type','uicontrol');
        h_ed = findobj(h_ed,'style','edit');
        val = 10^get(h_sl,'value');
        set(h_ed,'string',sprintf('%.2e',val));
        ax = findobj(fig,'type','axes');
        ud = get(fig,'userdata');
        h_sur = findobj(ax,'type','surface');
        p_val = get(ud.data,'p_value');
        p_val = p_val{ud.test_idx(1)};
        p_val = (p_val < val);
        set(h_sur,'cdata',double(p_val));
        ud.th_pval = val;
        set(fig,'userdata',ud);
    case 102    % update_plot: editbox
        h_ed = gco;
        fig = get(h_ed,'parent');
        h_sl = findobj(fig,'type','uicontrol');
        h_sl = findobj(h_sl,'style','slider');
        val = str2num(get(h_ed,'string'));
        lval = log10(val);
        mn = get(h_sl,'min');
        mx = get(h_sl,'max');
        if lval < mn
            lval = mn;
            val = 10^lval;
            set(h_ed,'string',num2str(val));
        elseif lval > mx
            lval = mx;
            val=10^lval;
            set(h_ed,'string',num2str(val));
        end
        set(h_sl,'value',lval);
        ax = findobj(fig,'type','axes');
        ud = get(fig,'userdata');
        h_sur = findobj(ax,'type','surface');
        p_val = get(ud.data,'p_value');
        p_val = p_val{ud.test_idx(1)};
        p_val = (p_val < val);
        set(h_sur,'cdata',double(p_val));
        ud.th_pval = val;
        set(fig,'userdata',ud);
    case 201    % plot_win_select_ci: O.K.
        this_fig = gcf;
        ci_level = str2num(get(ud.h_ed,'string'));
        ci_test = ud.available_ci(get(ud.h_lb,'value'),:);
        ud = get(fig,'userdata');
        switch str2keyword(ci_test,4)
            case 'symm'
                [low up] = ci(ud.data,'symmetric',ci_level);
        end
        ud.ci_view = 1;
        ud.ci_level = ci_level;
        ud.low = low;
        ud.up = up;
        set(fig,'userdata',ud);
        update_plot(fig);
        close(this_fig)
end