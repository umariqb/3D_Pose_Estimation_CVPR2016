function update_plot(fig)

% UPDATE_PLOT updates the plot(vsmatrix) figure.
% ----------------
% update_plot(fig)
% ----------------
% Description: main drawing function of plot(vsmatrix), updating the figure
%              each time the user changes anything.
% Input:       {fig} handle to main figure.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 08-Oct-2004

% initialization - get user data and main axes
axes(findobj(fig,'tag','ax_main'));
ud = get(fig,'userdata');
vsm = ud.data;
vars = ud.variables;
samp = ud.samples;
var_sort = ud.var_sort;
grp_sort = ud.grp_sort;
grp_view = ud.grp_view;
figure(fig), legend off;

% the plot the sorted data
rear = ud.rearrangement;
if novariables(vsm) == 1
    plot(samp,vsm.variables(rear),'p')
else
    plot(samp,vsm.variables(vars,rear),'p')
end

% restore the tag that was lost after the plot command, legend and labels
set(gca,'tag','ax_main','xlim',[samp(1)-1 samp(end)+1]);
xlim = get(gca,'xlim');     % for later use with grouping
if novariables(vsm) == 1
    legend(vsm.variables.name);
else
    legend(vsm.variables(vars).name);
end
xlabel('Samples'), ylabel('Variables')
set(get(gca,'children'),'hittest','off');

% plot grouping information
ax = findobj(fig,'tag','ax_grp');
if grp_view(1)
    % make this axes the current one and remove previous patches
    delete(get(ax,'children'));
    axes(ax);
    colormap jet;
    % get relevant grouping instance
    if length(vsm.groupings) == 1
        gr = vsm.groupings;
    else
        gr = vsm.groupings(grp_view(2));
    end
    h_level = grp_view(3);
    % get appropriate assignment and color vectors and rearrange if required
    ass = gr(h_level,rear);
    col = grp2col(gr,h_level);
    col = col(rear);
    % plot upper bars
    set(ax,'visible','on');
    % start patching
    df = diff(ass);
    idx = find(df);
    x_right = 0.5;
    for ii = 1:length(idx)
        % current nonzero index
        curr_idx = idx(ii);
        % update {x_left} and {x_right}
        x_left = x_right;
        x_right = curr_idx + 0.5;
        % context menu
        cmenu = uicontextmenu;
        uimenu(cmenu,'label',sprintf('Group: %s\n (%d)',...
            char(gr.naming{h_level}{ass(curr_idx)}),ass(curr_idx)));
        if x_right - x_left == 1
            uimenu(cmenu,'label',sprintf('Span: %d',curr_idx));
        else
            uimenu(cmenu,'label',sprintf('Span: %d-%d',x_left+0.5,curr_idx));
        end
        % patch
        h = patch([x_left x_left x_right x_right],[0 1 1 0],col(curr_idx));
        set(h,'uicontextmenu',cmenu,'linestyle','none');
    end
    % current nonzero index
    curr_idx = length(ass);
    % update {x_left} and {x_right}
    x_left = x_right;
    x_right = curr_idx + 0.5;
    % context menu
    cmenu = uicontextmenu;
    uimenu(cmenu,'label',sprintf('Group: %s\n (%d)',...
        char(gr.naming{h_level}(ass(curr_idx))),ass(curr_idx)));
    if x_right - x_left == 1
        uimenu(cmenu,'label',sprintf('Sample: %d',curr_idx));
    else
        uimenu(cmenu,'label',sprintf('Samples: %d-%d',x_left+0.5,curr_idx));
    end
    % patch
    h = patch([x_left x_left x_right x_right],[0 1 1 0],col(curr_idx));
    set(h,'uicontextmenu',cmenu,'linestyle','none');
    set(ax,'xlim',xlim);
    set(findobj(fig,'label','View Grouping'),'check','on');
else
    set(get(ax,'children'),'visible','off');
    set(ax,'visible','off');
    set(findobj(fig,'label','View Grouping'),'check','off');
end

% check/uncheck Options->Variables->Show All
h = findobj(findobj(findobj(fig,'type','uimenu'),'label','Variables'),'label','Show All');
if length(vars) == novariables(vsm)
    set(h,'check','on');
else
    set(h,'check','off');
end

% check/uncheck Options->Samples->Show All
h = findobj(findobj(findobj(fig,'type','uimenu'),'label','Samples'),'label','Show All');
if length(samp) == nosamples(vsm)
    set(h,'check','on');
else
    set(h,'check','off');
end

% check/uncheck Options->Sort by->Nothing
h = findobj(findobj(findobj(fig,'type','uimenu'),'label','Sort by'),'label','Nothing');
if isempty(var_sort) && isempty(grp_sort)
    set(h,'check','on');
else
    set(h,'check','off');
end