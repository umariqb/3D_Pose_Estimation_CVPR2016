function plot(cvm,num)

% PLOT plots the covariance/correlation matrix
% ---------
% plot(cvm)
% ---------
% Description: plots the covariance/correlation matrix.
% Input:       {cvm} covmatrix instance.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 04-Feb-2005

% {num} (2nd parameter) is just a trick that allows to keep the callbacks
% function in the private directory
if nargin == 2
    plot_callbacks(num);
    return;
end

% hard-coded parameters
MAX_NUM_OF_TEXT_TICKS_X = 25;
MAX_NUM_OF_TEXT_TICKS_Y = 25;

% list of available hypotheses and confidence intervals
hyp = {'independence (t-test)','independence (z-test)'};

% define figure
name = sprintf('%s matrix: %s',get(cvm,'type'),get(cvm,'name'));
fig = figure('numbertitle','off','name',name);

% define context-menu
cmenu = uicontextmenu('callback','plot(covmatrix,-1)');
uimenu(cmenu,'tag','item_1');
uimenu(cmenu,'tag','item_2');
uimenu(cmenu,'tag','item_3');
uimenu(cmenu,'tag','item_4');
uimenu(cmenu,'tag','item_5');
set(fig,'uicontextmenu',cmenu);

% prepare x-axis variable names for display later instead of ticks
no_vars = get(cvm,'no_cols');
var_text_horiz = [];
var_loc_horiz = [];
no_lines_horiz = 0;
if no_vars < MAX_NUM_OF_TEXT_TICKS_X
    no_lines_horiz = zeros(1,no_vars);
    WIDTH_MAX = 0.9;
    DELTA = 0.1;
    var_names = samplenames(get(cvm,'row_sampleset'));
    for ii = 1:no_vars
        str = disptext(var_names{ii},9);
        n = size(str,1);
        width = DELTA*(n-1);
        if width > WIDTH_MAX
            delta = WIDTH_MAX / (n-1);
            width = WIDTH_MAX;
        else
            delta = DELTA;
        end
        var_text_horiz = strvcat(var_text_horiz,str);   %#ok
        var_loc_horiz = [var_loc_horiz ii+0.5+width-2*delta*((1:n)-1)];
        no_lines_horiz(ii) = n;
    end
end

% prepare y-axis variable names for display later instead of ticks
no_vars = get(cvm,'no_rows');
var_text_vert = [];
var_loc_vert = [];
no_lines_vert = 0;
if no_vars < MAX_NUM_OF_TEXT_TICKS_Y
    no_lines_vert = zeros(1,no_vars);
    WIDTH_MAX = 0.9;
    DELTA = 0.1;
    var_names = samplenames(get(cvm,'row_sampleset'));
    for ii = 1:no_vars
        str = disptext(var_names{ii},9);
        n = size(str,1);
        width = DELTA*(n-1);
        if width > WIDTH_MAX
            delta = WIDTH_MAX / (n-1);
            width = WIDTH_MAX;
        else
            delta = DELTA;
        end
        var_text_vert = strvcat(var_text_vert,str); %#ok
        var_loc_vert = [var_loc_vert ii+0.5+width-2*delta*((1:n)-1)];
        no_lines_vert(ii) = n;
    end
end

% define user-data
if ~isempty(cvm.p_value)
    test_idx = [1 1];
else
    test_idx = [0 0];
end
ud = struct('data',cvm,'cmenu',cmenu,'main_fig',fig,...
    'th_view',0,'test_idx',test_idx,'th_pval',1e-3,...
    'ci_view',0,'ci_level',0.99,'low',[],'up',[],...
    'txt_horiz',var_text_horiz,'loc_horiz',var_loc_horiz,...
    'nl_horiz',no_lines_horiz,'txt_vert',var_text_vert,...
    'loc_vert',var_loc_vert,'nl_vert',no_lines_vert);
set(fig,'userdata',ud);

% define Options menu
men = uimenu(fig,'label','&Options','position',7);
% submenu Options->Hypothesis Testing
men_hypo = uimenu(men,'label','Hypothesis Testing');
% submenu Options->Hypothesis Testing->Available Hypotheses
uimenu(men_hypo,'label','None','check','on','callback','plot(covmatrix,2)');
for ii = 1:length(cvm.hypothesis)
    idx = find(strcmp(hyp,cvm.hypothesis{ii}));
    cmd = sprintf('uimenu(men_hypo,''label'',''%s'',''tag'',''[%d %d]'',''callback'',''plot(covmatrix,3)'');',...
        cvm.hypothesis{ii},ii,idx);
    eval(cmd);
end
% submenu Options->Confidence Interval
uimenu(men,'label','Confidence Interval...','callback','plot(covmatrix,4)');

% plot the data
plot_callbacks(1)