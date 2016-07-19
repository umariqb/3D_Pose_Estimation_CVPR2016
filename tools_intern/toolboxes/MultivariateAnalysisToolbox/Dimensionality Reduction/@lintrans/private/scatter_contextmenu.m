function scatter_contextmenu(ud)

% SCATTER_CONTEXTMENU callback for the scatter contextmenu.
% -----------------------
% scatter_contextmenu(ud)
% -----------------------
% Description: callback for the scatter contextmenu.
% Input:       {ud} userdata of parent window.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 18-Jan-2005

% extract relevant information from userdata structure
cmenu = ud.cmenu;
lt = ud.data;
U = get(lt,'U');
vars = ud.variables;

% get mouse location
location = get(gca,'currentpoint');
location = location(1,1:2);

% find closest sample point
data = U(:,vars).';
[mn vr] = min(distmat(location.',data));    %#ok
vr=vr(1);

% first contextmenu item
names = samplenames(lt.variableset);
str = sprintf('(%d) %s',vr,names{vr});
h = findobj(cmenu,'tag','item_1');
set(h,'label',str);