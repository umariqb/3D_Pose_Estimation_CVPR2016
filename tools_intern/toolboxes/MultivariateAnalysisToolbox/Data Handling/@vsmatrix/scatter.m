function scatter(vsm,num)

% SCATTER plots variables versus variables.
% ------------
% scatter(vsm)
% ------------
% Description: scatter plot of variables versus variables.
% Input:       {vsm} vsmatrix instance.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 10-Jan-2005

% {num} (2nd parameter) is just a trick that allows to keep the callbacks
% function in the private directory
if nargin == 2
    scatter_callbacks(num);
    return;
end

% define figure
name = sprintf('coordinate-based matrix: %s',get(vsm,'name'));
fig = figure('numbertitle','off','name',name);

% define axes
ax = subplot('position',[0.73 0.1 0.25 0.8]);
set(ax,'tag','ax_legend');
ax = subplot('position',[0.1 0.1 0.58 0.8]);
set(ax,'tag','ax_main');

% define contextmenu
cmenu = uicontextmenu('callback','scatter(vsmatrix,-1)');
uimenu(cmenu,'tag','item_1');
uimenu(cmenu,'tag','item_2');
set(ax,'uicontextmenu',cmenu);

% make nanless grouping
len = length(vsm.groupings);
if len == 1
    vsm.groupings = specifyunknowns(vsm.groupings);
    vsm.groupings = consistent(vsm.groupings);
elseif len > 1
    for ii = 1:len
        vsm.groupings(ii) = specifyunknowns(vsm.groupings(ii));
        vsm.groupings(ii) = consistent(vsm.groupings(ii));
    end
end

% which variables to plot on startup
vars = [1 2];
if novariables(vsm) == 1
    vars = [1 1];
end

% define user-data
ud = struct('data',vsm,'variables',vars,'cmenu',cmenu,'main_fig',fig,...
    'grp_view',1,'grp',1,'h_col',1,'h_cent',1,'reg_type',0,...
    'leg_view',1,'mark_size',[64 64],'ell_view',1,'reg_par',[],...
    'cent_view',0,'std_ell',1,'nop_ell',40,'lw_ell',0.5,...
    'ax_view',1,'lw_ax',1,'edges',1,'randomize',0);
if len == 0     % no grouping information available
    ud.grp_view = 0;
    ud.cent_view = 0;
end
set(fig,'userdata',ud);

% define Options menu
men = uimenu(fig,'label','&Options','position',7);
% submenu Options->Variables
uimenu(men,'label','Variables...','callback','scatter(vsmatrix,2)');
% submenu Options->Grouping
h = uimenu(men,'label','Grouping...','callback','scatter(vsmatrix,6)');
if len == 0     % no grouping information available
    set(h,'enable','off');
end
% submenu Options->Regress
men_reg = uimenu(men,'label','Regress','separator','on');
uimenu(men_reg,'label','None','callback','scatter(vsmatrix,7)');
uimenu(men_reg,'label','Intercept (y = ax + b)','callback','scatter(vsmatrix,8)');
uimenu(men_reg,'label','Slope (y = ax)','callback','scatter(vsmatrix,9)');
% submenu Options->View
men_view = uimenu(men,'label','View','separator','on');
h = uimenu(men_view,'label','Legend','check','on','callback','scatter(vsmatrix,3)');
if len == 0     % no grouping information available
    set(h,'enable','off');
end
h = uimenu(men_view,'label','Grouping','check','on','callback','scatter(vsmatrix,4)');
if len == 0     % no grouping information available
    set(h,'enable','off');
end
uimenu(men_view,'label','Settings...','callback','scatter(vsmatrix,5)');

% plot the data
scatter_callbacks(1)