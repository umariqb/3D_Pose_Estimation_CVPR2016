function similarity = matrix_comparison_similarity( compFunction, aggrFunction, showDetailsCategory, recomputeMatrix )
%       matrix = matrix_comparison_similarity( compFunction, aggrFunction, showDetailsCategory, constBoneLengths, recomputeMatrix )
%
%          Shoes similarity of motion classes referring to the given compFunction.
%               
%                compFunction:     'adv'           - advanced bitwise difference (not taking differences in run lengths into account)
%                                  'bitDiff'       - bitwise difference
%                                  'featureCurves' - std. dev. of difference of feature curves
%                                  'MTdiff'        - difference between Motion-Templates
%                aggrFunction:     'mean'          - aggregates by calculating the mean value of each category
%                                  'max'           - aggregates by taking the maximum value of each category
%                showDetailsCategory : determines right-click behaviour
%                constBoneLengths    : Enforce constant bonelengths after joint position estimation. Default = true.
%                recomputeMatrix     : Enforces recomputation of matrix

if nargin < 1
    help matrix_comparison
    return;
else
    if nargin < 2
        aggrFunction = 'mean';
    end
    if nargin < 3
        showDetailsCategory = true;
    end
    if nargin < 4
        constBoneLengths = true;
    end
    if nargin < 5
        recomputeMatrix = false;
    end
end

load HE_motion_classes;

matrix = matrix_comparison(compFunction, aggrFunction, 0, showDetailsCategory, recomputeMatrix );

for i=1:61 
    for j=1:61 
        similarity(i,j) = sum(abs(matrix(:,i) - matrix(:,j))); 
    end
end
figure;
imagesc(similarity, 'buttondownfcn', {@matrixOnClick, similarity, motion_classes});

axis off;
colormap('hot');
set(colorbar, 'Position', [0.935    0.251    0.02    0.7]);
set(colorbar, 'Fontsize', 7);

for i=1:length(motion_classes)
    h = text(-1, i, motion_classes{i});
    set(h, 'HorizontalAlignment', 'Right');
    set(h, 'Interpreter', 'None');
    set(h, 'FontSize', 5);
end

for i=1:length(motion_classes)
    h = text(i, length(motion_classes)+1.5, motion_classes{i});
    set(h, 'HorizontalAlignment', 'Right');
    set(h, 'Rotation', 55);
    set(h, 'FontSize', 5);
end

set(gca, 'Position', [0.22    0.25    0.7    0.7]);

% ------------------------------
function matrixOnClick(src, eventdata, similarity, motion_classes)

pointClicked = get(get(src, 'Parent'), 'CurrentPoint');
x = round(pointClicked(1,1));
y = round(pointClicked(1,2));
title([motion_classes{x} ' - ' motion_classes{y} '  ( ' num2str(similarity(x,y)) ' )']);
