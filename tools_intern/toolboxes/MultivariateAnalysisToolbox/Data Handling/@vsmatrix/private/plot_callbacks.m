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
    case 2  % Options->Variables->Show All
        vars = 1:novariables(ud.data);
        ud.variables = vars;
        set(fig,'userdata',ud);
        update_plot(fig);
    case 3  % Options->Variables->Select
        plot_win_select_variables(ud);
    case 4  % Options->Samples->Show All
        ud.samples = 1:get(ud.data,'no_samples');
        ud.rearrangement = ud.samples;
        set(fig,'userdata',ud);
        h_sort = findobj(findobj(fig,'type','uimenu'),'label','Sort by');
        set(h_sort,'enable','on');
        update_plot(fig);
    case 5  % Options->Samples->Select
        plot_win_select_samples(ud);
    case 6  % Options->Sort by->Variable
        plot_win_sort_variables(ud);
    case 7  % Options->Sort by->Group
        plot_win_sort_grouping(ud);
    case 8  % Options->Sort by->Nothing
        ud.var_sort = [];
        ud.grp_sort = [];
        ud.rearrangement = ud.samples;
        set(fig,'userdata',ud);
        update_plot(fig);
    case 9  % Options->View Grouping
        h = findobj(fig,'label','View Grouping');
        if strcmp(get(h,'check'),'on')
            activate_view = 0;
        else
            activate_view = 1;
        end
        ud.grp_view(1) = activate_view;
        set(fig,'userdata',ud);
        update_plot(fig);
    case 10 % Options->View Options
        plot_win_view_grouping(get(fig,'userdata'));
    case 101    % plot_win_select_samples: select all radiobutton
        set(ud.h_rb(1),'value',1);
        set(ud.h_rb(2:3),'value',0);
        set(ud.h_ed,'visible','off');
        set(ud.h_lb,'enable','off');
    case 102    % plot_win_select_samples: select specified radiobutton
        set(ud.h_rb(2),'value',1);
        set(ud.h_rb([1 3]),'value',0);
        set(ud.h_ed(1),'visible','on');
        set(ud.h_ed(2),'visible','off');
        set(ud.h_lb,'enable','on');
        set(ud.h_ed(1),'string',num2str(get(ud.h_lb,'value')));
    case 103    % plot_win_select_samples: select specified editable box
        set(ud.h_lb,'value',str2num(get(ud.h_ed(1),'string')));
    case 104    % plot_win_select_samples: unselect specified radiobutton
        set(ud.h_rb(3),'value',1);
        set(ud.h_rb(1:2),'value',0);
        set(ud.h_ed(2),'visible','on');
        set(ud.h_ed(1),'visible','off');
        set(ud.h_lb,'enable','on');
        set(ud.h_lb,'value',str2num(get(ud.h_ed(2),'string')));
    case 105    % plot_win_select_samples: unselect specified editable box
        set(ud.h_lb,'value',str2num(get(ud.h_ed(2),'string')));
    case 106    % plot_win_select_samples: listbox
        if get(ud.h_rb(2),'value')
            set(ud.h_ed(1),'string',num2str(get(ud.h_lb,'value')));
        else
            set(ud.h_ed(2),'string',num2str(get(ud.h_lb,'value')));
        end
    case 107    % plot_win_select_samples: O.K
        this_fig = gcf;
        vsm = ud.data;
        h_rb = ud.h_rb;
        if get(h_rb(1),'value')
            samp = 1:nosamples(vsm);
        elseif get(h_rb(2),'value')
            samp = get(ud.h_lb,'value');
        elseif get(h_rb(3),'value')
            samp=1:nosamples(vsm);
            samp(get(ud.h_lb,'value'))=[];
        end
        ud = get(fig,'userdata');
        ud.samples = samp;
        ud.rearrangement = samp;
        h_sort = findobj(findobj(fig,'type','uimenu'),'label','Sort by');
        if get(h_rb(1),'value')
            set(h_sort,'enable','on');
        else
            ud.var_sort = [];
            ud.grp_sort = [];
            set(h_sort,'enable','off');
        end
        set(fig,'userdata',ud);
        update_plot(fig);
        close(this_fig)
    case 201    % plot_win_select_variables: select all radiobutton
        set(ud.h_rb(1),'value',1);
        set(ud.h_rb(2:3),'value',0);
        set(ud.h_ed,'visible','off');
        set(ud.h_lb,'enable','off');
    case 202    % plot_win_select_variables: select specified radiobutton
        set(ud.h_rb(2),'value',1);
        set(ud.h_rb([1 3]),'value',0);
        set(ud.h_ed(1),'visible','on');
        set(ud.h_ed(2),'visible','off');
        set(ud.h_lb,'enable','on');
        set(ud.h_ed(1),'string',num2str(get(ud.h_lb,'value')));
    case 203    % plot_win_select_variables: select specified editbox
        set(ud.h_lb,'value',str2num(get(ud.h_ed(1),'string')));
    case 204    % plot_win_select_variables: unselect specified radiobutton
        set(ud.h_rb(3),'value',1);
        set(ud.h_rb(1:2),'value',0);
        set(ud.h_ed(2),'visible','on');
        set(ud.h_ed(1),'visible','off');
        set(ud.h_lb,'enable','on');
        set(ud.h_lb,'value',str2num(get(ud.h_ed(2),'string')));
    case 205    % plot_win_select_variables: unselect specified editbox
        set(ud.h_lb,'value',str2num(get(ud.h_ed(2),'string')));
    case 206    % plot_win_select_variables: listbox
        if get(ud.h_rb(2),'value')
            set(ud.h_ed(1),'string',num2str(get(ud.h_lb,'value')));
        else
            set(ud.h_ed(2),'string',num2str(get(ud.h_lb,'value')));
        end
    case 207    % plot_win_select_variables: O.K.
        this_fig = gcf;
        vsm = ud.data;
        if get(ud.h_rb(1),'value')
            vars = 1:novariables(vsm);
        elseif get(ud.h_rb(2),'value')
            vars = get(ud.h_lb,'value');
        elseif get(ud.h_rb(3),'value')
            vars = 1:novariables(vsm);
            vars(get(ud.h_lb,'value'))=[];
        end
        ud = get(fig,'userdata');
        ud.variables = vars;
        if ~isempty(ud.var_sort)
            idx = find(vars==ud.var_sort);
            if isempty(idx)
                ud.var_sort = [];
            end
        end
        set(fig,'userdata',ud);
        update_plot(fig);
        close(this_fig)
    case 301    % plot_win_sort_grouping: choose group listbox
        grp = get(ud.h_lb,'value');
        fud = get(fig,'userdata');
        vsm = fud.data;
        set(ud.h_txt,'string',sprintf('(of %d)',...
            vsm.groupings(grp).no_hierarchies));
    case 302    % plot_win_sort_grouping: O.K.
        this_fig = gcf;
        grp_sort(1) = get(ud.h_lb,'value');
        grp_sort(2) = str2num(get(ud.h_ed,'string'));
        ud = get(fig,'userdata');
        vsm = ud.data;
        [dummy idx] = sort(vsm.groupings(grp_sort(1),grp_sort(2),:));
        ud.var_sort = [];
        ud.rearrangement = idx;
        ud.grp_view(2:3) = grp_sort;
        ud.grp_view(1) = 1;
        ud.grp_sort = grp_sort;
        set(fig,'userdata',ud);
        update_plot(fig);
        close(this_fig)
    case 401    % plot_win_sort_variables: editbox
        vars = ud.variables;
        set(ud.h_lb,'value',find(vars==str2num(get(ud.h_ed,'string'))));
    case 402    % plot_win_sort_variables: listbox
        vars = ud.variables;
        set(ud.h_ed,'string',num2str(vars(get(ud.h_lb,'value'))));
    case 403    % plot_win_sort_variables: O.K.
        this_fig = gcf;
        var_sort = str2num(get(ud.h_ed,'string'));
        ud = get(fig,'userdata');
        vsm = ud.data;
        if length(vsm.variables)==1
            [dummy idx] = sort(vsm.variables(:));
        else
            [dummy idx] = sort(vsm.variables(var_sort,:));
        end
        ud.var_sort = var_sort;
        ud.rearrangement = idx;
        ud.grp_sort = [];
        set(fig,'userdata',ud);
        update_plot(fig);
        close(this_fig)
    case 501    % plot_win_view_grouping: choose group listbox
        grp = get(ud.h_lb,'value');
        fud = get(fig,'userdata');
        vsm = fud.data;
        set(ud.h_txt,'string',sprintf('(of %d)',...
            vsm.groupings(grp).no_hierarchies));
    case 502    % plot_win_view_grouping: O.K.
        this_fig = gcf;
        grp_view(1) = 1;
        grp_view(2) = get(ud.h_lb,'value');
        grp_view(3) = str2num(get(ud.h_ed,'string'));
        ud = get(fig,'userdata');
        ud.grp_view = grp_view;
        set(fig,'userdata',ud);
        h = findobj(fig,'label','View Grouping');
        set(h,'check','on');
        update_plot(fig);
        close(this_fig)
end