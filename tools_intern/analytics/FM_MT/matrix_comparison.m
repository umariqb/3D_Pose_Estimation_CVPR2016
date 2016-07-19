function [matrix, diffPerFeature] = matrix_comparison( compFunction, aggrFunction, thresh, showDetailsCategory, recomputeMatrix, fontSize )
% [matrix, diffPerFeature] = matrix_comparison( compFunction, aggrFunction, thresh, showDetailsCategory, recomputeMatrix, fontSize )
%
%          compFunction:     'adv'           - advanced bitwise difference (not taking differences in run lengths into account)
%                            'bitDiff'       - bitwise difference
%                            'featureCurves' - std. dev. of difference of feature curves
%                            'MTdiff'        - difference between Motion-Templates
%          aggrFunction:     'mean'          - aggregates by calculating the mean value of each category
%                            'max'           - aggregates by taking the maximum value of each category
%          thresh              : cuts matrix values below thresh to zero. Used as multiple of max(max(matrix)).
%          showDetailsCategory : determines right-click behaviour
%          recomputeMatrix     : Enforces recomputation of matrix
%          fontSize            : xLabel and yLabel font size

if nargin < 1
    help matrix_comparison
    return;
else
    switch lower(compFunction)
        case {'adv', 'bitdiff', 'featurecurves', 'featurecurvesadv', 'mtdiff'}
        otherwise 
            error('Unknown compFunction!');
    end
    if nargin < 2
        aggrFunction = 'mean';
    end
    
    switch lower(aggrFunction)
        case {'mean', 'max'}
        otherwise
            error('Unknown aggrFunction!');
    end
    if nargin < 3
        thresh = 0;
    end
    if nargin < 4
        showDetailsCategory = true;
    end
    if nargin < 5
        recomputeMatrix = false;
    end
    if nargin < 6
        fontSize = 6;
    end
end

dbs = dbstack;
fullPath = dbs(1).name(1:max(strfind(dbs(1).name, '\')));

load all_motion_classes;
categories = motion_classes;
feature_names = getFeatureNames;

global VARS_GLOBAL
dbPath = VARS_GLOBAL.dir_root;

dbName1 = 'HDM05_cut_amc';
dbName2 = 'HDM05_cut_c3d';

% filenames for load + save
matrixFilename = 'matrix';
diffFilename = 'diff';

if ( strcmpi(compFunction, 'mtdiff') || strcmpi(compFunction, 'mtDTW') )
    [diff, matrix] = motionTemplateComparison( compFunction, dbName1, dbName2, motion_classes );
    diffPerFeature = [];
else
    
    if recomputeMatrix
        for i=1:length(categories)
            
            [diff{i}, diffPerFeature{i}] = feature_comparison_category( compFunction, categories{i}, dbName1, dbName2 );
            
            %         matrix(:,i) = mean(diffPerFeature{i}, 2);
            switch lower(aggrFunction)
                case 'mean'
                    matrix(:,i) = mean(diffPerFeature{i}, 2);
                case 'max'
                    matrix(:,i) = max(diffPerFeature{i}, [], 2);
            end
            
        end
        save( fullfile(fullPath, 'Cache', [matrixFilename '_' aggrFunction '_' compFunction]), 'matrix');
        save( fullfile(fullPath, 'Cache', [diffFilename '_' aggrFunction '_' compFunction]), 'diffPerFeature');
    else
        load( fullfile(fullPath, 'Cache', [matrixFilename '_' aggrFunction '_' compFunction]) );
        load( fullfile(fullPath, 'Cache', [diffFilename '_' aggrFunction '_' compFunction]) );
    end
end

if thresh > 0
    matrix(find(matrix < thresh*max(max(matrix)))) = 0;
end

h=figure;
set(h, 'Name', [aggrFunction ' of ' compFunction]);

if strcmpi(compFunction, 'mtdiff')
    imagesc(matrix, 'buttondownfcn',{@mtDiffOnClick, categories, dbName1, dbName2})
else
    if showDetailsCategory
        imagesc(matrix, 'buttondownfcn',{@matrix_comparison_showCategory, ...
                compFunction, diffPerFeature, feature_names, categories, fullfile(dbPath, dbName1), fullfile(dbPath, dbName2), [0 max(max(cell2mat(diffPerFeature)))] })
    else
        imagesc(matrix, 'buttondownfcn',{@matrix_comparison_showFeature, ...
                compFunction, diffPerFeature, feature_names, categories, fullfile(dbPath, dbName1), fullfile(dbPath, dbName2), [0 max(max(cell2mat(diffPerFeature)))] })
    end
end
axis off;
colormap('hot');

for i=1:length(feature_names)
    h = text(-1, i, feature_names{i}(17:end-7));
    set(h, 'HorizontalAlignment', 'Right');
    set(h, 'Interpreter', 'None');
    set(h, 'FontSize', fontSize);
    set(h, 'ButtonDownFcn', @featureTextOnClick);
end

for i=1:length(categories)
    h = text(i, length(feature_names)+1.5, categories{i});
    set(h, 'HorizontalAlignment', 'Right');
    set(h, 'Rotation', 55);
    set(h, 'FontSize', fontSize-1);
end

% set(gcf, 'Position', [620 280 650 580]) 

children = get(gcf, 'Children');
set(children(1), 'YLim', [0 length(feature_names)+3.7]);
h = colorbar;
% pos = get(h,'Position');
% pos(3)=pos(3)/3;
% pos(1)=0.9;
set(h,'Position',[0.93    0.24    0.02    0.72]);
set(h, 'Fontsize', 7);
set(gca, 'Position', [0.2    0.18    0.72    0.79]);

% -----------------------------------------------------------
function featureTextOnClick(src, eventdata)
fullFeatureName = ['feature_AK_bool_' get(src, 'String') '_robust'];
    open(fullFeatureName);

function mtDiffOnClick(src, eventdata, categories,  dbName1, dbName2)
pointClicked = get(get(src, 'Parent'), 'CurrentPoint');
x = round(pointClicked(1,1));
y = round(pointClicked(1,2));

t = get(gcf,'selectionType');
if strcmpi(t, 'alt')    % right click
%     showTemplateComparison( categories{x}, dbName1, dbName2, true, false);
    showTemplateComparison( categories{x}, dbName1, dbName2, true, true);
else
    title(categories{x});
end