function plot(ssm,num)

% PLOT plots a distance matrix
% ----------
% plot(ssm)
% ----------
% Description: plots the ssmatrix.
% Input:       {ssm} ssmatrix instance.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 04-Apr-2006

% {num} (2nd parameter) is just a trick that allows to keep the callbacks
% function in the private directory
if nargin == 2
    plot_cb(num);
    return;
end

% hard-coded parameters
MAX_NUM_OF_TEXT_TICKS_X = 20;
MAX_NUM_OF_TEXT_TICKS_Y = 20;

% define figure
name = sprintf('%s matrix: %s',get(ssm,'type'),get(ssm,'name'));
fig = figure('numbertitle','off','name',name);

% define context-menu
cmenu = uicontextmenu('callback','plot(ssmatrix,-1)');
uimenu(cmenu,'tag','item_1');
uimenu(cmenu,'tag','item_2');
set(fig,'uicontextmenu',cmenu);

% prepare x-axis variable names for display later instead of ticks
no_samps = get(ssm,'no_cols');
samp_text_horiz = [];
samp_loc_horiz = [];
no_lines_horiz = 0;
if no_samps < MAX_NUM_OF_TEXT_TICKS_X
    no_lines_horiz = zeros(1,no_samps);
    WIDTH_MAX = 0.9;
    DELTA = 0.1;
    samps = get(ssm,'row_sampleset');
    for ii = 1:no_samps
        str = disptext(char(samps(ii)),9);
        n = size(str,1);
        width = DELTA*(n-1);
        if width > WIDTH_MAX
            delta = WIDTH_MAX / (n-1);
            width = WIDTH_MAX;
        else
            delta = DELTA;
        end
        samp_text_horiz = strvcat(samp_text_horiz,str); %#ok
        samp_loc_horiz = [samp_loc_horiz ii+0.5+width-2*delta*((1:n)-1)];
        no_lines_horiz(ii) = n;
    end
end

% prepare y-axis variable names for display later instead of ticks
no_samps = get(ssm,'no_rows');
samp_text_vert = [];
samp_loc_vert = [];
no_lines_vert = 0;
if no_samps < MAX_NUM_OF_TEXT_TICKS_Y
    no_lines_vert = zeros(1,no_samps);
    WIDTH_MAX = 0.9;
    DELTA = 0.1;
    samps = get(ssm,'rows_samples');
    for ii = 1:no_samps
        str = disptext(samps{ii},9);
        n = size(str,1);
        width = DELTA*(n-1);
        if width > WIDTH_MAX
            delta = WIDTH_MAX / (n-1);
            width = WIDTH_MAX;
        else
            delta = DELTA;
        end
        samp_text_vert = strvcat(samp_text_vert,str);   %#ok
        samp_loc_vert = [samp_loc_vert ii+0.5+width-2*delta*((1:n)-1)];
        no_lines_vert(ii) = n;
    end
end

% define user-data
ud = struct('data',ssm,'cmenu',cmenu,'main_fig',fig,...
    'th_view',0,'th_val',0,'txt_horiz',samp_text_horiz,...
    'loc_horiz',samp_loc_horiz,'nl_horiz',no_lines_horiz,...
    'txt_vert',samp_text_vert,'loc_vert',samp_loc_vert,...
    'nl_vert',no_lines_vert);
set(fig,'userdata',ud);

% define Options menu
men = uimenu(fig,'label','&Options','position',7);
% submenu Options->View
men_view = uimenu(men,'label','View');
% submenu Options->View->Color coding
uimenu(men_view,'label','Color coding','check','on',...
    'callback','plot(ssmatrix,2)');
% submenu Options->View->Thresholding
uimenu(men_view,'label','Thresholding','callback','plot(ssmatrix,3)');

% plot the data
plot_cb(1)