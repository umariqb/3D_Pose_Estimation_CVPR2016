function update_scree(fig)

% UPDATE_SCREE updates the scree diagram of a LINTRANS.
% -----------------
% update_scree(fig)
% -----------------
% Description: main drawing function of the scree diagram of a LINTRANS,
%              updating the figure each time the user changes anything.
% Input:       {fig} handle to main figure.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 17-Jan-2005

% initialization - get user data and main axes
axes(findobj(fig,'type','axes'));
ud = get(fig,'userdata');

% prepare {x_data} and {y_data}
lt = ud.data;
y_data = lt.f_eigvals;
if ud.cum_view
    y_data = cumsum(y_data);
end
x_data = 1:nofactors(lt);

% plot CI, if required
switch ud.ci_view
    case 0  % no CI
        plot(x_data,y_data,'bp')
    case 1  % symmetric CI
        switch lt.type
            case 'PCA'
                [low high] = cieigvals(lt,ud.ci_alpha,'symmetric');
                low = ud.scale_fact * low;
                high = ud.scale_fact * high;
                errorbar(x_data,y_data,low,high,'bp');
            case 'Fisher'
            case 'weighted PCA'
        end
    case 2  % asymmetric CI
        switch lt.type
            case 'PCA'
                [low high] = cieigvals(lt,ud.ci_alpha,'asymmetric');
                low = ud.scale_fact * low;
                high = ud.scale_fact * high;
                errorbar(x_data,y_data,low,high,'bp');
            case 'Fisher'
            case 'weighted PCA'
        end
end
set(gca,'xtick',x_data,'xlim',[0 x_data(end)+1]);
xlabel('Number of Factor');
ylabel('Fractional Importance');

% check/uncheck Options->Cumulative Plot & Options->View Errorbars
h_cum = findobj(findobj(fig,'label','&Options'),'label','Cumulative Plot');
h_ci = findobj(findobj(fig,'label','&Options'),'label','View Confidence Interval');
if ud.cum_view
    set(h_cum,'check','on');
    set(h_ci,'check','off','enable','off');
else
    set(h_cum,'check','off');
    if ud.ci_enb
        set(h_ci,'enable','on');
        if ud.ci_view
            set(h_ci,'check','on');
        else
            set(h_ci,'check','off');
        end
    end
end