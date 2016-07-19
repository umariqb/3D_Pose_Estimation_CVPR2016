function view(dg,num)

% VIEW plots a DIGRAPH
% --------
% view(dg)
% --------
% Description: plot of a DIGRAPH.
% Input:       {dg} DIGRAPH instance.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 09-Jan-2008

% {num} (2nd parameter) is just a trick that allows to keep the callbacks
% function in the private directory
if nargin > 1
    view_callbacks(num);
    return;
end

% define figure
name = sprintf('digraph: %s',get(dg,'name'));
fig = figure('numbertitle','off','name',name);
axes('tag','main_ax');

% default - edge handles
no_edges = noedges(dg);
edge_handles = zeros(1,no_edges);
arrow_handles = zeros(1,no_edges);
for edge = 1:no_edges
    edge_handles(edge) = line;
    arrow_handles(edge) = line('marker','o','linestyle','none');
end

% defaults - edge properties
edge_width = 2*ones(1,no_edges);
edge_color = zeros(no_edges,3);

% defaults - node properties
no_nodes = nonodes(dg);
node_size = 8*ones(1,no_nodes);
node_color = ones(no_nodes,1) * [204 204 153]/255;
node_handles = zeros(1,no_nodes);
for node = 1:no_nodes
    node_handles(node) = line('color','k','marker','o');
end

% defaults - node coordinates
node_Xalg = 'eigenproj';
node_Yalg = 'eigenproj';
[node_Xcoord node_Ycoord] = computecoordinates(dg,node_Xalg,node_Yalg);

% defaults - node labels
nlabel_text = get(dg,'node_name');
nlabel_handles = zeros(1,no_nodes);
for node = 1:no_nodes
    nlabel_handles(node) = text;
end

% defaults - label position
nlabel_Xparam = 0.01;
nlabel_Yparam = 0.05;
nlabel_Xshift = nlabel_Xparam*ones(1,no_nodes) * range(node_Xcoord);
nlabel_Yshift = nlabel_Yparam*ones(1,no_nodes) * range(node_Ycoord);
nlabel_horiz = cellstr(char(ones(no_nodes,1)*'left'))';
nlabel_vert = cellstr(char(ones(no_nodes,1)*'bottom'))';

% define user-data
ud = struct('data',dg,'main_fig',fig,...
    'node_Xalg',node_Xalg,'node_Yalg',node_Yalg,...
    'node_Xcoord',node_Xcoord,'node_Ycoord',node_Ycoord,...
    'node_handles',node_handles,...
    'node_size',node_size,'node_unit','unspecified',...
    'node_color',node_color,...
    'nlabel_text',{nlabel_text},'nlabel_handles',nlabel_handles,...
    'nlabel_Xparam',nlabel_Xparam,'nlabel_Yparam',nlabel_Yparam,...
    'nlabel_Xshift',nlabel_Xshift,'nlabel_Yshift',nlabel_Yshift,...
    'nlabel_horiz',{nlabel_horiz},'nlabel_vert',{nlabel_vert},...
    'arrow_handles',arrow_handles,'edge_handles',edge_handles,...
    'edge_width',edge_width,'edge_color',edge_color);
set(fig,'userdata',ud);

% define Options menu
men = uimenu(fig,'label','&Options','position',7);

% submenu Options->Nodes
h = uimenu(men,'label','Nodes');
% submenu Options->Nodes->Label
hh = uimenu(h,'label','Label');
% submenu Options->Nodes->Label->Text
uimenu(hh,'label','Text ...','callback','view(digraph,6)');
% submenu Options->Nodes->Label->Position
uimenu(hh,'label','Position ...','callback','view(digraph,14)');
% submenu Options->Nodes->Label->Font
uimenu(hh,'label','Font ...','callback','view(digraph,15)');
% submenu Options->Nodes->Size
uimenu(h,'label','Size ...','callback','view(digraph,4)');
% submenu Options->Nodes->Color
uimenu(h,'label','Color ...','callback','view(digraph,2)');
% submenu Options->Nodes->Coordinates
uimenu(h,'label','Coordinates ...','callback','view(digraph,7)');

% submenu Options->Edges
h = uimenu(men,'label','Edges');
% submenu Options->Edges->Width
uimenu(h,'label','Width ...','callback','view(digraph,3)');
% submenu Options->Edges->Color
uimenu(h,'label','Color ...','callback','view(digraph,9)');

% submenu Options->Save Settings
uimenu(men,'label','Save Settings','callback','view(digraph,5)');

% plot the data
view_callbacks(1)