function [difference, diffPerFeature, diffPerFrame, diffPerFeaturesAndFrame] = feature_comparison_adv(f1, f2, noGraphics, frameRange1, frameRange2, showFMs)

showResults = false;

if nargin < 1   % demo mode ;)
    f1 = {'D:\Uni\HDM05\HDM05_cut_c3d\cartwheelLHandStart1Reps\HDM_bd_cartwheelLHandStart1Reps_004_120.C3D', ...
            'D:\Uni\HDM05\HDM05_cut_c3d\elbowToKnee1RepsLelbowStart\HDM_bd_elbowToKnee1RepsLelbowStart_001_120.C3D'};
    f2 = {'D:\Uni\HDM05\HDM05_cut_amc\cartwheelLHandStart1Reps\HDM_bd_cartwheelLHandStart1Reps_004_120.AMC', ...
            'D:\Uni\HDM05\HDM05_cut_amc\elbowToKnee1RepsLelbowStart\HDM_bd_elbowToKnee1RepsLelbowStart_001_120.AMC'};
%     f1 = {'C:\Mocap\HDM05\HDM05_cut_c3d_dipl\elbowToKnee1RepsLelbowStart\HDM_bk_elbowToKnee1RepsLelbowStart_011_120.C3D'};
%     f2 = {'C:\Mocap\HDM05\HDM05_cut_amc_dipl\elbowToKnee1RepsLelbowStart\HDM_bk_elbowToKnee1RepsLelbowStart_011_120.AMC'};
    showResults = true;
end

if nargin < 6
    showFMs = false;
end

if nargin < 3
    noGraphics = false;
end

constBoneLengths = true;

if ~iscell(f1)
    files1{1} = f1;
else
    files1 = f1;
end
if ~iscell(f2)
    files2{1} = f2;
else
    files2 = f2;
end

if length(files1)~=length(files2)
    error('Number of files in both cell-arrays must be the same for one-to-one comparison!');
end

b = length(files1);
m = floor(sqrt(b));

if m*m ~= b
    m = m + 1;
end

n = double(int32(b/m));

if mod(b,m)~=0
    n = n + 1;
end

for k=1:length(files1)
    
    fAMC = [];    fC3D = [];    f = [];    intervals = [];    nonzero = [];
    map = [0.2 0.2 0.2; 0.8 0.8 0.8]; % colormap
    mapDiff= [0.2 0.2 0.2; 0.5 0.5 0.5; 0.8 0.8 0.8; 0.7 0.0 0.0; 1.0 0.3 0.3];
    
    info = filename2info(files1{k});
    
    if strcmpi(info.filetype, 'ASF/AMC')
        temp = files1;
        files1 = files2;
        files2 = temp;
    end
    
    load('features_spec');
    
    %%%%%%% AK lower upper mix
    range = [70:83 58:69 84:96];
    fspec = features_spec(range);
    featureNames = {fspec.name}';
    
    [featuresAMC,fs,trAMC,tfAMC] = features_extract_single_file(files2{k}, fspec, false, constBoneLengths);
    [featuresC3D,fs,trC3D,tfC3D] = features_extract_single_file(files1{k}, fspec, false, constBoneLengths);
    FeatureDifference = cell2mat(featuresC3D) - cell2mat(featuresAMC);

    % remove later :)
    % *************************************************************************    
    if showFMs
        figure;
        imagesc(cell2mat(featuresAMC), [0 1]);
        colormap(gray); 
        set(gcf, 'name', ['... ' files2{k}(end-25:end)]);
        set(gca, 'position', [0.28    0.07    0.7    0.9])    
        set(gcf,'pos',[250   170   370   710]);
        set(gca, 'yticklabel', []);
        
        for i=1:length(featureNames)
            h = text(-0.5, i, featureNames{i}(17:end-7));
            set(h, 'HorizontalAlignment', 'Right');
            set(h, 'Interpreter', 'None');
            set(h, 'FontSize', 7);
        end
        if (nargin > 4) && (~isempty(frameRange1))
            r = rectangle('Position', [frameRange1(1)-0.5 0.6 (frameRange1(2) - frameRange1(1)) 38.8]);
            set(r, 'EdgeColor', [1 0 0]);
        end
        
        figure;
        imagesc(cell2mat(featuresC3D), [0 1]);
        colormap(gray); 
        set(gcf, 'name', ['... ' files1{k}(end-25:end)]);
        set(gca, 'position', [0.28    0.07    0.7    0.9])    
        set(gcf,'pos',[900   170   370   710]);   
        set(gca, 'yticklabel', []);

        for i=1:length(featureNames)
            h = text(-0.5, i, featureNames{i}(17:end-7));
            set(h, 'HorizontalAlignment', 'Right');
            set(h, 'Interpreter', 'None');
            set(h, 'FontSize', 7);
        end
        if (nargin > 5) && (~isempty(frameRange2))
            r = rectangle('Position', [frameRange2(1)-0.5 0.6 (frameRange2(2) - frameRange2(1)) 38.8]);
            set(r, 'EdgeColor', [1 0 0]);
        end
        
    end
    % *************************************************************************    

    
    diffReturn{k} = zeros(size(FeatureDifference));
    
    for i=1:length(featuresAMC)
        fAMC{i} = [1 find(diff([logical(1) featuresAMC{i}])~=0)];
    end
    
    for i=1:length(featuresC3D)
        fC3D{i} = [1 find(diff([logical(1) featuresC3D{i}])~=0)];
    end
    
    for i=1:length(featuresAMC)
        f{i} = [fC3D{i} fAMC{i}];
        f{i} = sort(f{i}(1,:));
        if mod(length(f{i}),2)~=0
            f{i}(end+1) = length(featuresAMC{1});
        end
    end
    
    % determine intervals, where the two feature sequences differ
    for i=1:length(f)
        intervals{i}(:).start = f{i}(1,1:2:end);
        intervals{i}(:).end = f{i}(1,2:2:end);
        if i==17
            disp('');
        end
        % todo: ist das ok? oder nur gerade anzahl löschen?
        nonzero = find(intervals{i}(:).end - intervals{i}(:).start);
        if not(isempty(nonzero))
            intervals{i}(:).start = intervals{i}(:).start(nonzero);
            intervals{i}(:).end = intervals{i}(:).end(nonzero);
        end
    end
    
    % inspect intervals
    for i=1:length(intervals)
        for j=1:length(intervals{i}.start)
            start = intervals{i}.start(j);
            stop  = intervals{i}.end(j);
            if start > 1    % => delete entries with start==1?
                if ((featuresAMC{i}(start-1) ~= featuresAMC{i}(start))  && (featuresAMC{i}(stop) ~= featuresAMC{i}(start))) ...
                        || ((featuresC3D{i}(start-1) ~= featuresC3D{i}(start))  && (featuresC3D{i}(stop) ~= featuresC3D{i}(start))) 
                    %                 disp(['detected malicious difference: feature ' num2str(i) ', ' num2str(start) ' - ' num2str(stop)]);
                    FeatureDifference(i,start:stop-1) = 0.5*FeatureDifference(i,start:stop-1) + 2.5;  % maps -1 => +2 and +1 => +3 (for colormap)
                    diffReturn{k}(i, start:stop-1) = 1;
                end
            end
        end
    end
    
    % figure;
    % imagesc(cell2mat(featuresC3D));
    % colormap(map);
    % title(files1{k},'Interpreter', 'none');
    % grid minor;
    % 
    % figure;
    % h=imagesc(cell2mat(featuresAMC));
    % colormap(map);
    % title(files2{k},'Interpreter', 'none');
    % grid minor;
    
    if ~noGraphics
        figure;
        subplot(m,n,k);
        imagesc(FeatureDifference, 'buttondownfcn',{@animateOnClick, files1{k}, files2{k} });
        
        mapDiff = mapDiff(1:max(max(FeatureDifference))+2,:);  % make sure that nothing's painted red if there are no critical differences
        colormap(mapDiff);
        %     colorbar;
        if b > 1
            grid;
        else 
%             axis off;
%             set(gca, 'DataAspectRatio', [size(FeatureDifference,2)+50 size(FeatureDifference,1) 1]);
            set(gca, 'Position', [0.3 0.08 0.65 0.88]);
            for i=1:length(featureNames)
                h = text(-2, i, featureNames{i}(17:end-7));
                set(h, 'HorizontalAlignment', 'Right');
                set(h, 'Interpreter', 'None');
                set(h, 'FontSize', 7);
                set(h, 'ButtonDownFcn', @featureTextOnClick);
            end
            grid minor;
%             set(gcf, 'Position', [5 280 610 580]);
            
%             xLabels = get(gca, 'XTickLabel');
%             xLabels = char(ones(size(xLabels))*32);
%             set(gca, 'XTickLabel', xLabels);
            yLabels = get(gca, 'YTickLabel');
            yLabels = char(ones(size(yLabels))*32);
            set(gca, 'YTickLabel', yLabels);
            
        end
        %     title({'light: feature 1 in C3D, dark: feature 1 in AMC', 'red: malicious differences', ['Files: ' info.amcname(1:end-4)]}, 'Interpreter', 'none');
%         title({info.amcname(1:end-4), 'bright: C3D==1, AMC==0'}, 'Interpreter', 'none');
    end
    
end

if length(diffReturn) > 1
    for k=1:length(diffReturn)
        diffPerFeature{k} = sum(abs(diffReturn{k}),2)/size(diffReturn{k},2);
        difference{k} = sum(sum(abs(diffReturn{k})))/size(diffReturn{k},1)/size(diffReturn{k},2);
    end
else
    diffPerFeature = sum(abs(diffReturn{1}),2)/size(diffReturn{1},2);
    difference = sum(sum(abs(diffReturn{1})))/size(diffReturn{1},1)/size(diffReturn{1},2);
end



% -------------------------------------------------------------------------

function animateOnClick(src, eventdata, fileName1, fileName2)

[skel1, mot1] = readMocapSmartLCS(fileName1, true);
[skel2, mot2] = readMocapSmartLCS(fileName2, true);

t = get(gcf,'selectionType');

% try to find animation window
titleText = 'compareJoint animation figure';
children = get(0, 'Children');
animationWindow = [];
for i=1:length(children)
    if strcmpi( titleText, get(children(i), 'Name') )
        animationWindow = children(i);
    end
end

if isempty(animationWindow)
    h=figure;
    set(h, 'Name', titleText);
else
    set(0, 'CurrentFigure', animationWindow);
end

speed = 0.3;
if strcmpi(t, 'alt')    % right click
    animate(skel2, mot2, 1, speed);
elseif strcmpi(t, 'extend') % middle click
    animate([skel1, skel2], [mot1, mot2], 1, speed);
else
    animate(skel1, mot1, 1, speed);
end

% -----------------------------------------------------------
function featureTextOnClick(src, eventdata)
fullFeatureName = ['feature_AK_bool_' get(src, 'String') '_robust'];
open(fullFeatureName);
