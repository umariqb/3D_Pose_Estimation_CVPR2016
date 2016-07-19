function [matrix, stdDevs] = matrixComparison( compFunction, aggrFunction, recomputeMatrix )
%   [matrix, stdDevs] = matrixComparison( compFunction, aggrFunction, recomputeMatrix )
%
%                       compFunction:     'std'   - standard variance
%                                         'mean'  - mean abs. difference
%                                         'deriv' - max. derivative of abs. difference
%                                         'max'   - max. abs. difference
%                                         'dft'   - spectral distance
%                       aggrFunction:     'mean'  - aggregates by calculating the mean value of each category
%                                         'max'   - aggregates by taking the maximum value of each category
%                       recomputeMatrix : Enforces recomputation of matrix

if nargin < 1
    help matrixComparison
    return;
else
    switch lower(compFunction)
        case {'std', 'mean', 'deriv', 'max', 'dft'}
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
end

dbs = dbstack;
fullPath = dbs(1).name(1:max(strfind(dbs(1).name, '\')));

load HE_motion_classes;

global VARS_GLOBAL
dbPath = VARS_GLOBAL.dir_root;

dbName1 = 'HDM05_cut_amc';
dbName2 = 'HDM05_cut_c3d';

if nargin < 3
    recomputeMatrix = false;
end

% filenames for load + save
matrixFilename = 'matrix';

if recomputeMatrix
    for i=1:length(motion_classes)
        disp(motion_classes{i});
        categoryMatrix = matrixComparisonCategory( compFunction, dbName1, dbName2, motion_classes{i}, true);
        
        switch lower(aggrFunction)
            case 'mean'
                matrix(:,i) = mean(categoryMatrix, 2);
            case 'max'
                matrix(:,i) = max(categoryMatrix, [], 2);
        end
    end
    save( fullfile(fullPath, 'Cache', [matrixFilename '_' aggrFunction '_' compFunction]), 'matrix');
        
else
    load( fullfile(fullPath, 'Cache', [matrixFilename '_' aggrFunction '_' compFunction]) );
end

% compute means
[n, m] = size(matrix);
maxEntry = max(max(matrix));

h = figure;

switch lower(compFunction)
    case 'std'
        compText = 'Average std. dev.';
    case 'mean'
        compText = 'Average abs. traj.-diff.';
    case 'deriv'
        compText = 'Average derivative of traj.-diff.';
    case 'max'
        compText = 'Maximum abs. traj.-diff.';
    case 'dft'
        compText = 'Summed DFT-difference';
end


set(h, 'Name', [compText ' per joint and motion class ']);

imagesc(matrix, 'buttondownfcn',{@matrixComparison_showMatrixEntry, compFunction, dbName1, dbName2, motion_classes })
%axis tight;
axis off;
% title('CLICK IMAGE FOR DETAILS!', 'Interpreter', 'none');
xlabel('motion classes');
% ylabel('joints');

joints = getAllJointNames;
for i=1:length(joints)
    h = text(0, i, joints{i});
    set(h, 'HorizontalAlignment', 'Right');
    set(h, 'FontSize', 8);
end

for i=1:length(motion_classes)
    h = text(i, length(joints)+1, motion_classes{i});
    set(h, 'HorizontalAlignment', 'Right');
    set(h, 'Rotation', 55);
    set(h, 'FontSize', 6);
end

children = get(gcf, 'Children');
set(children(1), 'YLim', [0 length(joints)+3.7]);
% colormap('hot');
hot2 = hot; hot2 = [hot2; hot2(32:64,:)]; hot2 = sort(hot2);
colormap(hot2)
h = colorbar;
% pos = get(h,'Position');
% pos(3)=pos(3)/3;
% pos(1)=0.9;
set(h,'Position',[0.9   0.22    0.02    0.735]);
set(gca, 'Position', [0.1    0.12    0.78    0.85]);

% [i,j]=max([stdDevs{:,2}]);

% disp(['Maximal stdDev. (' num2str(i) ') was taken for ' stdDevs{j,1} '.']);