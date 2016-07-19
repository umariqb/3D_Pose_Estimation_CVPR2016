function plot_contextmenu(ud)

% PLOT_CONTEXTMENU callback for the plot contextmenu.
% --------------------
% plot_contextmenu(ud)
% --------------------
% Description: callback for the plot contextmenu.
% Input:       {ud} userdata of parent window.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 07-Mar-2006

% extract relevant information from userdata structure
idx = ud.rearrangement;
cmenu = ud.cmenu;
vsm = ud.data;

% find mouse location
location = get(gca,'currentpoint');
location = location(1,1:2);

% find the closest sample and variable
samp = idx(round(max(min(location(1),nosamples(vsm)),1)));
[dumm vari] = min(abs(ud.data.variables(:,samp) - location(2)));    %#ok

% first contextmenu item
if ud.grp_view(1)
    if length(vsm.groupings) == 1
        gr = vsm.groupings;
    else
        gr = vsm.groupings(ud.grp_view(2));
    end
    h_level = ud.grp_view(3);
    str = sprintf('Group: %s (%d)',...
        char(gr.naming{h_level}(gr(h_level,samp))),...
        gr(h_level,samp));
    h = findobj(cmenu,'tag','item_1');
    set(h,'label',str);
end

% second contextmenu item
str = sprintf('Variable: %s (%d)',vsm.variables(vari).name,vari);
h = findobj(cmenu,'tag','item_2');
set(h,'label',str);

% third contextmenu item
sampnames = samplenames(vsm);
str = sprintf('Sample: %s (%d)',sampnames{samp},samp);
h = findobj(cmenu,'tag','item_3');
set(h,'label',str);