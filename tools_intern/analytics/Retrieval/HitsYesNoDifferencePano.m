function HitsYesNoDifferencePano( DB1, DB2, recompute, tau )
%   HitsYesNoDifferencePano( DB1, DB2, recompute, tau )

global VARS_GLOBAL

saveFileName = 'hitsYesNoDifference_cache';

if nargin < 2
    DB1 = 'HDM05_cut_c3d_dipl';
    DB2 = 'HDM05_cut_amc_dipl';
end

if nargin < 3
    recompute = false;
end

if nargin < 4
%     tau = 0.01;
        tau = 1;
end

dbs = dbstack;
fullPath = dbs(1).name(1:max(strfind(dbs(1).name, '\')));

load he_motion_classes;
load HE_DB_info;

keyframesThreshLo = 0.1;
par.thresh_lo = keyframesThreshLo;
par.thresh_hi = 1-par.thresh_lo;

load(['retrieval_results_' DB1 '_' DB1 '_' num2str(1000*par.thresh_lo)]);
VARS_GLOBAL.HitsYesNoDifferenceResults1 = results;

load(['retrieval_results_' DB2 '_' DB2 '_' num2str(1000*par.thresh_lo)]);
VARS_GLOBAL.HitsYesNoDifferenceResults2 = results;
clear results;

if recompute
    
    for i=1:length(motion_classes)
        motionClass = motion_classes{i};
        disp(motionClass);
        
        idx1 = strmatch(motionClass, {VARS_GLOBAL.HitsYesNoDifferenceResults1.category}', 'exact');
        idx2 = strmatch(motionClass, {VARS_GLOBAL.HitsYesNoDifferenceResults2.category}', 'exact');
        
        hitIdx1 = find([VARS_GLOBAL.HitsYesNoDifferenceResults1(idx1).hits.cost] < tau);
        hitIdx2 = find([VARS_GLOBAL.HitsYesNoDifferenceResults2(idx2).hits.cost] < tau);
        
        if isempty(hitIdx1) || isempty(hitIdx2)
            error('Motion class not contained in results!');
        end
        
        hits1 = VARS_GLOBAL.HitsYesNoDifferenceResults1(idx1).hits(hitIdx1);
        hits2 = VARS_GLOBAL.HitsYesNoDifferenceResults2(idx2).hits(hitIdx2);
        
        [precision{1,i}, recall{1,i}, n_relevant{1,i}] = precision_recall(motionClass, hits1, false, DB_info);
        [precision{2,i}, recall{2,i}, n_relevant{2,i}] = precision_recall(motionClass, hits2, false, DB_info);
    end
    save(fullfile(fullPath, 'Cache', saveFileName), 'recall', 'precision', 'n_relevant');
else
    load(fullfile(fullPath, 'Cache', saveFileName));
end

for i=1:length(motion_classes)
    hitYesNo1(i,1:length(recall{1,i})) = diff([0 recall{1,i}*n_relevant{1,i}]);
    hitYesNo2(i,1:length(recall{2,i})) = diff([0 recall{2,i}*n_relevant{2,i}]);
%     hitYesNo1(i,1:length(recall2{1,i})) = diff([0 recall2{1,i}*n_relevant2{1,i}]);
%     hitYesNo2(i,1:length(recall2{2,i})) = diff([0 recall2{2,i}*n_relevant2{2,i}]);
end

range = [1:min(min(size(hitYesNo1,2), size(hitYesNo2,2)), 50)];

% figure;
% imagesc(hitYesNo1(:, range));
% title(DB1, 'Interpreter', 'none');
% colormap(hot);
% 
% figure;
% imagesc(hitYesNo2(:, range));
% title(DB2, 'Interpreter', 'none');
% colormap(hot);

figure;
imagesc(hitYesNo1(:, range)' - hitYesNo2(:, range)');
colormap([0 0 1; 1 1 1; 1 0 0]);
h=ylabel('Position');
set(h, 'fontsize', 7);

for i=1:length(motion_classes)
    h = text(i, length(range)*1.05, motion_classes{i});
    set(h, 'HorizontalAlignment', 'Right');
    set(h, 'Rotation', 55);
    set(h, 'FontSize', 6);
    set(h, 'ButtonDownFcn', @motionClassTextOnClick);
%     set(h, 'ButtonDownFcn', {@motionClassTextOnClick, results1, results2});
end

set(gca,  'Position', [0.1    0.3    0.85    0.65]);
set(gcf, 'Position', [236   417   712   413]);
set(gca, 'xticklabel', [])
set(gca, 'fontsize', 7);

% -----------------------------------------------------------
function motionClassTextOnClick(src, eventdata)

global VARS_GLOBAL

t = get(gcf,'selectionType');

motionClass = get(src, 'string');
resultIdx1 = strmatch(motionClass, {VARS_GLOBAL.HitsYesNoDifferenceResults1.category}, 'exact');
resultIdx2 = strmatch(motionClass, {VARS_GLOBAL.HitsYesNoDifferenceResults2.category}, 'exact');
resultBrowser(motionClass);
set(gcf, 'position', [ 5   231   560   650]);

showDeltaDiff2( VARS_GLOBAL.HitsYesNoDifferenceResults2(resultIdx2).hits, VARS_GLOBAL.HitsYesNoDifferenceResults1(resultIdx1).hits, motionClass);
set(gcf, 'position', [  572     8   560   446]);

showDeltaDiff2( VARS_GLOBAL.HitsYesNoDifferenceResults1(resultIdx1).hits, VARS_GLOBAL.HitsYesNoDifferenceResults2(resultIdx2).hits, motionClass);
set(gcf, 'position', [ 572   462   560   420]);

