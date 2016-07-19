function nodexc_win(ud)

% NODEXC_WIN opens a window for editing node x-coordinate.
% --------------
% nodexc_win(ud)
% --------------
% Description: opens a window for editing node x-coordinate.
% Input:       {ud} userdata of parent window.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 10-Jan-2008

% internal variable for control size
no_nodes = length(ud.node_size);
c_rows = ceil(no_nodes/3);  % number of coordiante rows
p_rows = 3;                 % number of radio buttons
b_rows = 1;                 % size of OK and Cancel buttons
d_rows = 1;                 % size of spacer between blocks
tot_rows = c_rows + p_rows + b_rows + 4*d_rows;
delta = 1 / tot_rows;

% open window
fig_height = min(30*tot_rows,960);
fig = figure('menubar','none','position',[300 40 600 fig_height],...
    'numbertitle','off','name','Node Coordinates');

% algorithms for obtaining coordinates
p_height = p_rows*delta;
py = 1 - (d_rows + p_rows)*delta;
hpx = uipanel(fig,'title','x-coordinates',...
    'position',[0.05 py 0.4 p_height]);
hpy = uipanel(fig,'title','y-coordinates',...
    'position',[0.55 py 0.4 p_height]);
h_rbx = zeros(1,p_rows+1);
h_rby = zeros(1,p_rows+1);
P = 0.8;
d = 1 / (p_rows + 1 - P);
h = P * d;
y = 0.5*(1 + d*(p_rows-1) - h);
counter = 1;
h_rbx(counter) = uicontrol(hpx,'style','radio',...
    'string','Eigenprojection (without masses)',...
    'units','normalized','position',[0.1 y 0.8 h],...
    'callback','view(digraph,[352 1])');
h_rby(counter) = uicontrol(hpy,'style','radio',...
    'string','Eigenprojection (without masses)',...
    'units','normalized','position',[0.1 y 0.8 h],...
    'callback','view(digraph,[352 2])');
y = y - d;
counter = counter + 1;
h_rbx(counter) = uicontrol(hpx,'style','radio',...
    'string','Eigenprojection (with masses)',...
    'units','normalized','position',[0.1 y 0.8 h],...
    'callback','view(digraph,[352 1])');
h_rby(counter) = uicontrol(hpy,'style','radio',...
    'string','Eigenprojection (with masses)',...
    'units','normalized','position',[0.1 y 0.8 h],...
    'callback','view(digraph,[352 2])');
y = y - d;
counter = counter + 1;
h_rbx(counter) = uicontrol(hpx,'style','radio','string','Workspace',...
    'units','normalized','position',[0.1 y 0.8 h],...
    'callback','view(digraph,[352 1])');
h_rby(counter) = uicontrol(hpy,'style','radio','string','Workspace',...
    'units','normalized','position',[0.1 y 0.8 h],...
    'callback','view(digraph,[352 2])');
counter = counter + 1;
h_rbx(counter) = uicontrol(hpx,'style','push','string','L',...
    'units','normalized','position',[0.03 y 0.05 h],...
    'callback','view(digraph,[352 1])');
h_rby(counter) = uicontrol(hpy,'style','push','string','L',...
    'units','normalized','position',[0.03 y 0.05 h],...
    'callback','view(digraph,[352 2])');
switch ud.node_Xalg
    case 'eigenproj'
        set(h_rbx(1),'value',1);
    case 'eigenprojm'
        set(h_rbx(2),'value',1);
    case 'workspace'
        set(h_rbx(3),'value',1);
end
switch ud.node_Yalg
    case 'eigenproj'
        set(h_rby(1),'value',1);
    case 'eigenprojm'
        set(h_rby(2),'value',1);
    case 'workspace'
        set(h_rby(3),'value',1);
end

% coordinates for x and y
p_height = c_rows*delta;
py = py - (d_rows + c_rows)*delta;
hp = uipanel(fig,'title','coordinates (x,y)',...
    'position',[0.05 py 0.9 p_height]);

% decide how many full columns
full_columns = rem(no_nodes,3);
if full_columns == 0
    full_columns = 3;
end

% x-spacing
spac = 0.5;
hd = 0.25 / (3 + spac);

% write full columns
P = 0.8;
d = 1 / (c_rows + 1 - P);
h = P * d;
x = spac*hd;
y0 = 0.5*(1 + d*(c_rows-1) - h);
node = 0;
h_ed = zeros(no_nodes,2);
for col = 1:full_columns
    y = y0;
    for row = 1:c_rows
        node = node + 1;
        str = sprintf('Node %d (%s):',node,ud.nlabel_text{node});
        uicontrol(hp,'style','text','string',str,...
            'units','normalized','position',[x y 2*hd h],...
            'background',[0.8 0.8 0.8],'horizontal','left');
        h_ed(node,1) = uicontrol(hp,'style','edit',...
            'string',num2str(ud.node_Xcoord(node),'%.2f'),...
            'units','normalized','position',[x+2*hd y hd h],...
            'background',[0.8 0.8 0.8],'horizontal','left');
        h_ed(node,2) = uicontrol(hp,'style','edit',...
            'string',num2str(ud.node_Ycoord(node),'%.2f'),...
            'units','normalized','position',[x+3*hd y hd h],...
            'background',[0.8 0.8 0.8],'horizontal','left');
        y = y - d;
    end
    x = x + 4*hd + spac*hd;
end

% write partial columns
for col = (full_columns+1):3
    y = y0;
    for row = 1:(c_rows-1)
        node = node + 1;
        str = sprintf('Node %d (%s):',node,ud.nlabel_text{node});
        uicontrol(hp,'style','text','string',str,...
            'units','normalized','position',[x y 2*hd h],...
            'background',[0.8 0.8 0.8],'horizontal','left');
        h_ed(node,1) = uicontrol(hp,'style','edit',...
            'string',num2str(ud.node_Xcoord(node),'%.2f'),...
            'units','normalized','position',[x+2*hd y hd h],...
            'background',[0.8 0.8 0.8],'horizontal','left');
        h_ed(node,2) = uicontrol(hp,'style','edit',...
            'string',num2str(ud.node_Ycoord(node),'%.2f'),...
            'units','normalized','position',[x+3*hd y hd h],...
            'background',[0.8 0.8 0.8],'horizontal','left');
        y = y - d;
    end
    x = x + 4*hd + spac*hd;
end

% define OK and Cancel buttons
p_height = b_rows*delta;
py = py - (d_rows + b_rows)*delta;
uicontrol(fig,'style','push','string','O.K.',...
    'units','normalized','position',[0.125 py 0.3 p_height],...
    'callback','view(digraph,351)');
uicontrol(fig,'style','push','string','Cancel',...
    'units','normalized','position',[0.575 py 0.3 p_height],...
    'callback','close(gcf)');

% define userdata
ud = struct('h_ed',h_ed,'h_rbx',h_rbx,'h_rby',h_rby,...
    'main_fig',ud.main_fig);
set(gcf,'userdata',ud);