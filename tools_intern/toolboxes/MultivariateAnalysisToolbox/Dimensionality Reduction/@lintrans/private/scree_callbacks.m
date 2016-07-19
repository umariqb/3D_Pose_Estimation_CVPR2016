function scree_callbacks(num)

% SCREE_CALLBACKS lists the callback functions of SCREE.
% --------------------
% scree_callbacks(num)
% --------------------
% Description: lists the callback functions of SCREE.
% Input:       {num} each number defines a different callback.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 17-Jan-2005

% find main figure and axes
ud = get(gcf,'userdata');
fig = ud.main_fig;

switch num
    case 1  % update plot
        update_scree(fig);
    case 2  % Options->Cumulative Plot
        h = findobj(findobj(fig,'label','&Options'),...
            'label','Cumulative Plot');
        if strcmp(get(h,'check'),'on')
            ud.cum_view = 0;
        else
            if ud.ci_view
                ud.ci_view_hist = ud.ci_view;
                ud.ci_view = 0;
            end
            ud.cum_view = 1;
        end
        set(fig,'userdata',ud);
        update_scree(fig);
    case 3  % Options->View Confidence Interval
        h = findobj(findobj(fig,'label','&Options'),...
            'label','View Confidence Interval');
        if strcmp(get(h,'check'),'on')
            ud.ci_view_hist = ud.ci_view;
            ud.ci_view = 0;
        else
            ud.ci_view = ud.ci_view_hist;
        end
        set(fig,'userdata',ud);
        update_scree(fig);
    case 4  % Options->View Settings
        scree_win_view_settings(ud);
    case 101  % scree_win_view_settings: cumulative plot checkbox
        fud = get(fig,'userdata');
        if get(ud.h_ch(1),'value')
            if fud.ci_enb
                set(ud.h_ch(2),'enable','off','value',0);
                set(ud.h_rb(1:2),'enable','off');
                set(ud.h_ed,'enable','off');
                set(ud.h_txt,'enable','off');
            end
        else
            if fud.ci_enb
                set(ud.h_ch(2),'enable','on','value',0);
            end
        end
    case 102  % scree_win_view_settings: CI view checkbox
        if get(ud.h_ch(2),'value')
            set(ud.h_rb(1:2),'enable','on');
            set(ud.h_ed,'enable','on');
            set(ud.h_txt,'enable','on');
        else
            set(ud.h_rb(1:2),'enable','off');
            set(ud.h_ed,'enable','off');
            set(ud.h_txt,'enable','off');
        end
    case 103  % scree_win_view_settings: STD radiobutton
        set(ud.h_rb(1),'value',1);
        set(ud.h_rb(2),'value',0);
    case 104  % scree_win_view_settings: CI radiobutton
        set(ud.h_rb(1),'value',0);
        set(ud.h_rb(2),'value',1);
    case 105  % scree_win_view_settings: O.K.
        this_fig = gcf;
        fud = get(fig,'userdata');
        fud.cum_view = get(ud.h_ch(1),'value');
        fud.ci_view = 0;
        if get(ud.h_ch(2),'value')
            fud.ci_alpha = 0.01 * str2num(get(ud.h_ed,'string'));
            if get(ud.h_rb(1),'value')
                fud.ci_view = 1;
            else
                fud.ci_view = 2;
            end
        end
        set(fig,'userdata',fud);
        update_scree(fig);
        close(this_fig)
end