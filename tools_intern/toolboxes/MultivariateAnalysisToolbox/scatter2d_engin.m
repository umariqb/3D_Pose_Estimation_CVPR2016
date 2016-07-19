function fig = scatter2d_engin(varargin)

% SCATTER2D_ENGIN the engine used for 2D scatter plots.
% --------------------------------------------------------------------
% fig = scatter2d_engin(hndl, data, gr, h_col, h_cent, k_ell, no_ell,
%       lw_ell, markshape, marksize, tit, xlab, ylab, info_str, flags)
% --------------------------------------------------------------------
% Description: the engine used for 2D scatter plots.
% Input:       {hndl} a handle to figure. If is -1, a new figure is opened
%                   (same as using the 'newfig' flag). If it is strictly
%                   positive, the current figure is not cleared. If it is
%                   0, either a new figure is opened, or the current figure
%                   is cleared.
%              {data} {2}-by-{n} data matrix, with {n} the number of data
%                   points.
%              {gr} grouping instance. If empty, no grouping information is
%                   available and 'nolegend' is automatically assumed.
%              {h_col} hierarchy that determining the coloring. If empty,
%                   no group coloring is preformed.
%              {h_cent} hierarchy that determining the centroids. If empty,
%                   centroids are not plotted.
%              {k_ell} the width of the ellipse in units of STD. If zero,
%                   ellipses are not plotted.
%              {no_ell} number of points in the ellipses. If zero, ellipses
%                   are not plotted.
%              {lw_ell} line width used for plotting the ellipses.
%              {markshape} scatter marker shape.
%              {marksize} scatter marker size. If a scalar, the marker size
%                   of data and centroids is the same, if a 2-vector then
%                   markersize(1) is the size of the data points, while
%                   markersize(2) is the size of the centroid points.
%              {tit} the title of the drawing. If [], current title is
%                   kept. 
%              {xlab} the x-label of the drawing. if [], current label is
%                   kept. 
%              {ylab} the y-label of the drawing. if [], current label is
%                   kept. 
%              {info_str} description of the specific plot.
%              <{flags}> determines certain plotting parameters
%                   'nolegend' - no legend

% © Liran Carmel
% Classification: Visualization
% Last revision date: 09-Dec-2004

% set input parameters to intrinsic variables
idx = 1;
hndl = varargin{idx}; idx = idx + 1;
data = varargin{idx}; idx = idx + 1;
gr = varargin{idx}; idx = idx + 1;
h_col = varargin{idx}; idx = idx + 1;
h_cent = varargin{idx}; idx = idx + 1;
k_ell = varargin{idx}; idx = idx + 1;
no_ell = varargin{idx}; idx = idx + 1;
lw_ell = varargin{idx}; idx = idx + 1;
markshape = varargin{idx}; idx = idx + 1;
marksize = varargin{idx}; idx = idx + 1;
if nodims(marksize) == 0
    marksize = [marksize marksize];
end
tit = varargin{idx}; idx = idx + 1;
xlab = varargin{idx}; idx = idx + 1;
ylab = varargin{idx}; idx = idx + 1;

% read flags
legend_flag = true;
for ii = idx:nargin
    switch str2keyword(varargin{ii},3)
        case 'nol'
            legend_flag = false;
    end
end
if isempty(gr)
    legend_flag = false;
end

% prepare figure for plotting
if hndl == -1
    fig = figure;
elseif hndl == 0
    fig = gcf;
    clf;
else
    fig = hndl;
end

% generate main axes
if hndl > 0
    ax_leg = findobj(fig,'tag','ax_legend');
else
    ax_leg = subplot('position',[0.73 0.1 0.25 0.8]);
    set(ax_leg,'tag','ax_legend');
    ax = subplot('position',[0.1 0.1 0.58 0.8]);
    set(ax,'tag','ax_main');
end
set(ax_leg,'visible','off');

% generate color vectors
if ~isempty(h_col)
    [col_samp col_groups] = grp2col(gr,h_col);
else
    col_samp = ones(1,size(data,2));
    col_groups = 1;
end

% the following is require to prevent a bug that happens when there are
% exactly three groups or three samples
if length(col_groups) == 3
    col_groups = real2rgb(col_groups);
end
if length(col_samp) == 3
    col_samp = real2rgb(col_samp);
end

% plot the data with black borders around the scatter points
hold on
scatter(data(1,:),data(2,:),marksize(1),col_samp,markshape,'filled');
set(findobj(gca,'type','patch'),'markeredgecolor','k');

% plot centroids
if ~isempty(h_cent)
    data_cent = gmean(gr,data,h_cent);
    scatter(data_cent(1,:),data_cent(2,:),marksize(2),col_groups,markshape);
end

% plot ellipses
if min(size(col_groups)) == 1
    col_groups = real2rgb(col_groups);
end
if no_ell > 0 && k_ell > 0 && ~isempty(h_cent)
    data_ell = gcov(gr,data,h_cent);
    no_cent = gr.no_groups(h_cent);
    for ii = 1:no_cent
        % find the ellipses
        [rot D] = eig(data_ell(:,:,ii));
        ax = k_ell * sqrt(diag(D));
        if any(ax < eps)
            ell = data_cent(:,ii) * ones(1,2*(no_ell-1));
        else
            ell = ellipse(ax',data_cent(:,ii).',rot,no_ell);
        end
        % plot the ellipses
        if isempty(h_col)
            line(ell(1,:),ell(2,:),'color',col_groups,'linewidth',lw_ell);
        else
            line(ell(1,:),ell(2,:),'color',col_groups(ii,:),'linewidth',lw_ell);
        end
    end
end

% set axes properties
set(gca,'box','on','xgrid','on','ygrid','on');
set(get(gca,'children'),'hittest','off');

% set labels
if ~isempty(tit)
   title(tit)
end
if ~isempty(xlab)
   xlabel(xlab)
end
if ~isempty(ylab)
   ylabel(ylab)
end

% plot the legend
if legend_flag
    set(gca,'position',[0.1 0.1 0.58 0.8]);
    axes(ax_leg);
    no_groups = gr.no_groups(h_col);
    dy = 1 / (no_groups + 1);               % vertical step
    y_coord = 1;
    hold on
    % plot the legend
    for ii = 1:no_groups
        y_coord = y_coord - dy;
        scatter(0,y_coord,marksize(1),col_groups(ii,:),'filled');
        text(0.2,y_coord,gr.naming{h_col}{ii},'FontSize',7);
    end
    hold off
    % apply black borders to the points
    set(findobj(gca,'type','patch'),'markeredgecolor','k');
    set(gca,'xlim',[-0.2 2],'ylim',[0 1],'xtick',[],'ytick',[],...
        'visible','on','box','on');
else
    set(gca,'position',[0.1 0.1 0.8 0.8]);
end