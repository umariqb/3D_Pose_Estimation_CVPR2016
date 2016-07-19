function scatter_contextmenu(ud)

% SCATTER_CONTEXTMENU callback for the plot contextmenu.
% -----------------------
% scatter_contextmenu(ud)
% -----------------------
% Description: callback for the plot contextmenu.
% Input:       {ud} userdata of parent window.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 09-Dec-2004

% extract relevant information from userdata structure
cmenu = ud.cmenu;
vsm = ud.data;
vars = ud.variables;

% get mouse location
location = get(gca,'currentpoint');
location = location(1,1:2);

% find closest sample point
if novariables(vsm) == 1
    data = [vsm.variables(:) ; vsm.variables(:)];
else
    data = vsm.variables(vars,:);
end
[mn samp] = min(distmat(location.',data));  %#ok
samp=samp(1);

% first contextmenu item
if ud.grp_view
    gr = instance(vsm.groupings,num2str(ud.grp));
    h_level = ud.h_col;
    str = sprintf('Group: %s (%d)',...
        char(gr.naming{h_level}(gr(h_level,samp))),...
        gr(h_level,samp));
    h = findobj(cmenu,'tag','item_1');
    set(h,'label',str);
end

% second contextmenu item
samples = samplenames(vsm);
if ~isempty(samples)
    str = sprintf('Sample: %s (%d)',samples{samp},samp);
    h = findobj(cmenu,'tag','item_2');
    set(h,'label',str);
end