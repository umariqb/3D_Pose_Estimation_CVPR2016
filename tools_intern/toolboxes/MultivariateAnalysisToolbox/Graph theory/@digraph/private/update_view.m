function update_view(fig)

% UPDATE_VIEW updates the view(digraph) figure.
% ----------------
% update_view(fig)
% ----------------
% Description: main drawing function of view(digraph), updating the
%              figure each time the user changes anything.
% Input:       {fig} handle to main figure.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 09-Jan-2008

% initialization - get user data and main axes
figure(fig);
ud = get(fig,'userdata');

% prepare data
dg = ud.data;
no_nodes = nonodes(dg);
x = ud.node_Xcoord;
y = ud.node_Ycoord;

% plot dots & label
for node = 1:no_nodes
    set(ud.node_handles(node),'xdata',x(node),...
        'ydata',y(node),...
        'markersize',ud.node_size(node),...
        'markerfacecolor',ud.node_color(node,:));
    set(ud.nlabel_handles(node),'position',...
        [x(node)+ud.nlabel_Xshift(node) y(node)+ud.nlabel_Yshift(node) 0],...
        'string',ud.nlabel_text{node},'horizontal',ud.nlabel_horiz{node},...
        'vertical',ud.nlabel_vert{node});
end

% plot all lines
W = get(dg,'weights');
THD = get(dg,'thd');
ecounter = 0;
for node1 = 1:(no_nodes-1)
    node2 = node1 + find(W(node1,(node1+1):no_nodes));
    for edge = 1:length(node2)
        ecounter = ecounter + 1;
        if THD(node1,node2(edge)) > 0
            xdata = [x(node1) x(node2(edge))];
            ydata = [y(node1) y(node2(edge))];
        else
            xdata = [x(node2(edge)) x(node1)];
            ydata = [y(node2(edge)) y(node1)];
        end
        set(ud.edge_handles(ecounter),...
            'xdata',xdata,'ydata',ydata,...
            'linewidth',ud.edge_width(ecounter),...
            'color',ud.edge_color(ecounter,:));
        xdata = xdata(1) + 0.75*diff(xdata);
        ydata = ydata(1) + 0.75*diff(ydata);
        set(ud.arrow_handles(ecounter),...
            'xdata',xdata,'ydata',ydata,...
            'markersize',4*ud.edge_width(ecounter),...
            'MarkerEdgeColor',ud.edge_color(ecounter,:),...
            'MarkerFaceColor',ud.edge_color(ecounter,:));
    end
end

% beautify the plot
xrng = range(x);
xlim = [min(x)-0.1*xrng max(x)+0.1*xrng];
if xrng == 0
    % digraph is comprised of a single node
    xlim = [0.9 1.1];
end
yrng = range(y);
ylim = [min(y)-0.1*yrng max(y)+0.1*yrng];
set(gca,'xlim',xlim,'ylim',ylim,'box','on','xtick',[],'ytick',[])
set(gca,'xcolor','w','ycolor','w');

% update userdata
set(fig,'userdata',ud);