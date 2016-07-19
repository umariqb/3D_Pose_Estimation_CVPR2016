function update_bar(fig)

% UPDATE_BAR updates the bar view of the loadings plot of LINTRANS.
% ---------------
% update_bar(fig)
% ---------------
% Description: main drawing function of the bar view of the loading
%              plot of LINTRANS, updating the figure each time the user
%              changes anything.
% Input:       {fig} handle to main figure.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 18-Jan-2005

% initialization - get user data and main axes
axes(findobj(fig,'tag','ax_legend')); cla
set(gca,'visible','off');
axes(findobj(fig,'tag','ax_main')); cla
ud = get(fig,'userdata');
lt = ud.data;
vars = ud.variables;

% plot data
no_orig_vars = lt.no_variables;
name_vars = samplenames(lt.variableset);
bar(1:no_orig_vars,lt.U(:,vars(1)).',ud.bar_width);
xlabel(' ')
str = sprintf('Relative impact on %s',name_vars{vars(1)});
ylabel(str);
set(gca,'tag','ax_main','xtick',[],'position',[0.1 0.1 0.8 0.8]);
set(gca,'xlim',[0.5 no_orig_vars+0.5]);
set(get(gca,'children'),'hittest','off');
line(get(gca,'xlim'),[0 0],'color','k','linewidth',ud.lw_ax);

% restore variable names (x-axis)
N = 50; Y_POS = get(gca,'ylim') * [N+1 ; -1] / N;
names = ud.txt_horiz;
pos = ud.loc_horiz;
h_horiz = zeros(1,length(pos));
for ii = 1:length(pos)
    h_horiz(ii) = text(pos(ii),Y_POS,names(ii,:));
end
set(h_horiz,'rotation',270,'fontsize',7);

% check/uncheck Options->Scatter plot and Options->Bar plot
h = findobj(fig,'label','Scatter plot');
set(h,'check','off');
h = findobj(fig,'label','Bar plot');
set(h,'check','on');

% disable Options->View->Legend
h = findobj(fig,'label','Legend');
set(h,'enable','off');

% update userdata
set(fig,'userdata',ud);