function showTemplateComparison( category, DB_name1, DB_name2, visBool, visReal )
% showTemplateComparison( category, DB_name1, DB_name2 )

if nargin < 5
    visReal = false;
end

if nargin < 4
    visBool = true;
end
    
if (nargin < 2  || isempty(DB_name1))
    DB_name1 = 'HDM05_cut_amc';
    DB_name2 = 'HDM05_cut_c3d';
end

if nargin < 1   % demo mode :)
    category = 'grabFloorR';
end

feature_names = getFeatureNames;

% load templates
downsampling_fac = 4;
sampling_rate_string = num2str(120/downsampling_fac);
settings = ['5_0_' sampling_rate_string];
feature_set = {'AK_upper','AK_lower','AK_mix'};
feature_set_ranges = {1:14,15:26,27:39};

basedir_templates1 = fullfile(DB_name1,'_templates','');
basedir_templates2 = fullfile(DB_name2,'_templates','');
[motionTemplateReal1, motionTemplateWeights1] = motionTemplateLoadMatfile(basedir_templates1,category,feature_set,settings);
[motionTemplateReal2, motionTemplateWeights2] = motionTemplateLoadMatfile(basedir_templates2,category,feature_set,settings);

param.thresh_lo = 0.1;
param.thresh_hi = 1-param.thresh_lo;
param.visBool = 0;
param.visReal = 0;
param.visBoolRanges = 0;
param.visRealRanges = 0;
param.feature_set_ranges = feature_set_ranges;
param.feature_set = feature_set;
param.flag = 0;

[motionTemplate1, weights1] = motionTemplateBool(motionTemplateReal1,motionTemplateWeights1,param);
[motionTemplate2, weights2] = motionTemplateBool(motionTemplateReal2,motionTemplateWeights1,param);

if visReal
    figure;
    imagesc(motionTemplateReal1, [0 1]);
    colormap(hot);
    
    for i=1:length(feature_names)
        h = text(-0.5, i, feature_names{i}(17:end-7));
        set(h, 'HorizontalAlignment', 'Right');
        set(h, 'Interpreter', 'None');
        set(h, 'FontSize', 7);
    end
    
    set(gca, 'Yticklabel', []);
    set(gca, 'position', [0.28    0.07    0.7    0.9])    
    set(gcf, 'Name', [DB_name1 ' - ' category]);
    set(gcf,'pos',[260   170   345   710]);
   
    % template 2
    figure;
    imagesc(motionTemplateReal2, [0 1]);
    colormap(hot);
    
    for i=1:length(feature_names)
        h = text(-0.5, i, feature_names{i}(17:end-7));
        set(h, 'HorizontalAlignment', 'Right');
        set(h, 'Interpreter', 'None');
        set(h, 'FontSize', 7);
    end
    
    set(gca, 'Yticklabel', []);
    set(gca, 'position', [0.28    0.07    0.7    0.9])    
    set(gcf, 'Name', [DB_name2 ' - ' category]);
    set(gcf,'pos',[900   170   380   710]);   
    
end

if visBool
    figure;
    imagesc(motionTemplate1, [0 1]);
    colormap(gray);
    
    for i=1:length(feature_names)
        h = text(-0.5, i, feature_names{i}(17:end-7));
        set(h, 'HorizontalAlignment', 'Right');
        set(h, 'Interpreter', 'None');
        set(h, 'FontSize', 7);
    end
    
    set(gca, 'Yticklabel', []);
    set(gca, 'position', [0.28    0.07    0.7    0.9])    
    set(gcf, 'Name', [DB_name1 ' - ' category]);
    set(gcf,'pos',[5   170   345   710]);
   
    % template 2
    figure;
    imagesc(motionTemplate2, [0 1]);
    colormap(gray);
    
    for i=1:length(feature_names)
        h = text(-0.5, i, feature_names{i}(17:end-7));
        set(h, 'HorizontalAlignment', 'Right');
        set(h, 'Interpreter', 'None');
        set(h, 'FontSize', 7);
    end
    
    set(gca, 'Yticklabel', []);
    set(gca, 'position', [0.28    0.07    0.7    0.9])    
    set(gcf, 'Name', [DB_name2 ' - ' category]);
    set(gcf,'pos',[620   170   380   710]);   

    % difference 2-1
%     minLen = min(size(motionTemplate2, 2), size(motionTemplate1, 2));
%     figure;
%     imagesc( abs(motionTemplate2(:,1:minLen)-motionTemplate1(:,1:minLen)), [0 1]);
%     colormap(gray);
%     
%     for i=1:length(feature_names)
%         h = text(-0.5, i, feature_names{i}(17:end-7));
%         set(h, 'HorizontalAlignment', 'Right');
%         set(h, 'Interpreter', 'None');
%         set(h, 'FontSize', 7);
%     end
%     
%     set(gca, 'Yticklabel', []);
%     set(gca, 'position', [0.28    0.07    0.7    0.9])    
%     set(gcf, 'Name', [DB_name2 ' - ' category]);
%     set(gcf,'pos',[515   170   500   710]);   
    
end

