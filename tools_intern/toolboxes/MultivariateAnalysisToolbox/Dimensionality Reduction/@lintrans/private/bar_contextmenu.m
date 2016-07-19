function bar_contextmenu(ud)

% BAR_CONTEXTMENU callback for the bar contextmenu.
% -------------------
% bar_contextmenu(ud)
% -------------------
% Description: callback for the bar contextmenu.
% Input:       {ud} userdata of parent window.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 19-Mar-2004

% extract relevant information from userdata structure
cmenu = ud.cmenu;
lt = ud.data;
U = get(lt,'U');
vars = ud.variables;

% get mouse location and find closest variable
location = get(gca,'currentpoint');
vr = round(location(1,1));

% first contextmenu item
str = sprintf('(%d) %s',vr,lt.orig_vars{vr});
h = findobj(cmenu,'tag','item_1');
set(h,'label',str);

% second contextmenu item
str = sprintf('value: %f',U(vr,vars(1)));
h = findobj(cmenu,'tag','item_2');
set(h,'label',str);