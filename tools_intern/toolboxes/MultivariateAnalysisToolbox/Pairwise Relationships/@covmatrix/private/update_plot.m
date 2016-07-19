function update_plot(fig)

% UPDATE_PLOT updates the plot(covmatrix) figure.
% ----------------
% update_plot(fig)
% ----------------
% Description: main drawing function of plot(covmatrix), updating the
%              figure each time the user changes anything.
% Input:       {fig} handle to main figure.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 04-Mar-2006

% initialization - get user data and main axes
ud = get(fig,'userdata');
cvm = ud.data;

% discriminate between plot of correlation and thresholding
figure(ud.main_fig);
delete(findobj(gcf,'type','axes'));
delete(findobj(gcf,'type','uicontrol'));
if ud.th_view == 0
    pseudocolor(get(cvm,'matrix'),[-1 1]); colormap(microarraycolormap)
    ax = findobj(gcf,'tag','','type','axes');
    set(ax,'tag','ax_main');
else
    p_val = (cvm.p_value{ud.test_idx(1)} < ud.th_pval);
    pseudocolor(p_val); colormap bw
    ax = findobj(gcf,'tag','','type','axes');
    set(ax,'tag','ax_main');
    pos = get(ax,'position');
    delete(findobj(gcf,'tag','Colorbar'));
    set(ax,'position',pos)
    uicontrol(fig,'style','slider','min',-16,'max',-1,...
        'sliderstep',[0.1 1],'value',log10(ud.th_pval),...
        'units','normalized','position',[0.85 0.11 0.03 0.815],...
        'callback','plot(covmatrix,101)');
    uicontrol(fig,'style','text','string','p-value:',...
        'background',[0.8 0.8 0.8], ...
        'units','normalized','position',[0.8 0.94 0.08 0.04]);
    uicontrol(fig,'style','edit','string',sprintf('%.0e',ud.th_pval),...
        'background',[0.8 0.8 0.8], ...
        'units','normalized','position',[0.88 0.94 0.12 0.04],...
        'callback','plot(covmatrix,102)');
    uicontrol(fig,'style','text','background',[0 0 0],...
        'units','normalized','position',[0.82 0.06 0.025 0.03]);
    uicontrol(fig,'style','text','background',[1 1 1],...
        'units','normalized','position',[0.82 0.02 0.025 0.03]);
    uicontrol(fig,'style','text','background',[0.8 0.8 0.8],...
        'units','normalized','position',[0.85 0.06 0.1 0.03],...
        'string','Dependent!');
    uicontrol(fig,'style','text','background',[0.8 0.8 0.8],...
        'units','normalized','position',[0.85 0.02 0.1 0.03],...
        'string','Indecisive');
end

% restore variable names (x-axis)
if ~isempty(ud.loc_horiz)
    set(ax,'xtick',[]);
    Y_POS = 0.95;
    names = ud.txt_horiz;
    pos = ud.loc_horiz;
    h_horiz = zeros(1,length(pos));
    for ii = 1:length(pos)
        h_horiz(ii) = text(pos(ii),Y_POS,names(ii,:));
    end
    set(h_horiz,'rotation',270,'fontsize',7);
end

% restore variable names (y-axis)
if ~isempty(ud.loc_vert)
    set(ax,'ytick',[]);
    X_POS = 0.95;
    names = ud.txt_vert;
    pos = ud.loc_vert;
    h_vert = zeros(1,length(pos));
    for ii = 1:length(pos)
        h_vert(ii) = text(X_POS,pos(ii),deblank(names(ii,:)));
    end
    set(h_vert,'horizontal','right','fontsize',7);
end

% associate uicontextmenu with the surface plot
h = findobj(get(ax,'children'),'type','surface');
set(h,'uicontextmenu',ud.cmenu);

% make confidence intervals enabled or disables
h = findobj(fig,'label','Confidence Interval...');
if strcmp(cvm.cov_type,'pearson')
    set(h,'enable','on');
else
    set(h,'enable','off');
end

% make hypothesis testing enabled or disables
h = findobj(fig,'label','Hypothesis Testing');
if ~isempty(cvm.p_value)
    set(h,'enable','on');
else
    set(h,'enable','off');
end