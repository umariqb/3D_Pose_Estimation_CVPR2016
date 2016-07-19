function scree(lt,num)

% SCREE plots a scree diagram of the transformation eigenvalues.
% ---------
% scree(lt)
% ---------
% Description: plots a scree diagram of the transformation eigenvalues.
% Input:       {lt} LINTRANS instance.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 18-Jan-2005

% {num} (2nd parameter) is just a trick that allows to keep the callbacks
% function in the private directory
if nargin == 2
    scree_callbacks(num);
    return;
end

% define figure
name = sprintf('%s: Scree diagram',lt.type);
fig = figure('numbertitle','off','name',name); axes

% defaults view parameters
cum_view = 0;   % whether cumulative plot or not
ci_enb = 0;     % whether confidence interval is enabled
ci_view = 0;    % 0 - don't show CI, 1 - show symm. CI, 2 - show asymm. CI
ci_view_hist = 0; % history of {erb_view}
ci_alpha = 0.95;  % significance level of CI
scale_fact = 1/sum(lt.eigvals);   % scaling factor
switch lt.type
    case 'PCA'
        ci_view = 2;
        ci_enb = 1;
    case 'Fisher'
    case 'weighted PCA'
end

% define user-data
ud = struct('data',lt,'main_fig',fig,'cum_view',cum_view,...
    'ci_enb',ci_enb,'ci_view',ci_view,'ci_view_hist',ci_view_hist,...
    'ci_alpha',ci_alpha,'scale_fact',scale_fact);
set(fig,'userdata',ud);

% define Options menu
men = uimenu(fig,'label','&Options','position',7);
% submenu Options->Cumulative Plot
h = uimenu(men,'label','Cumulative Plot','check','off',...
    'callback','scree(lintrans,2)');
if cum_view
    set(h,'check','on');
end
% submenu Options->View Confidence Interval
h = uimenu(men,'label','View Confidence Interval','check','off',...
    'enable','off','callback','scree(lintrans,3)');
if ci_view
    set(h,'check','on');
end
if ci_enb
    set(h,'enable','on');
end
% submenu Options->View Settings
uimenu(men,'label','View Settings...','callback','scree(lintrans,4)');

% plot the data
scree_callbacks(1)