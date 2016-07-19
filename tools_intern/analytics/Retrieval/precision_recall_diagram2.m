function [ output_args ] = precision_recall_diagram2( DB_info, mClasses, results1, results2, recompute, m, n, tau1, tau2 )

dbs = dbstack;
fullPath = dbs(1).name(1:max(strfind(dbs(1).name, '\')));
saveFileName = 'precision_recall_diagram_cache';


if ~iscell(mClasses)
    motionClasses{1} = mClasses;
else
    motionClasses = mClasses;
end


if nargin > 3
    if strfind(lower(inputname(3)), 'c3d')
        labelTxt1 = 'LCS';
    elseif strfind(lower(inputname(3)), 'amc')
        labelTxt1 = 'ASF/AMC';
    end
    
    if strfind(lower(inputname(4)), 'c3d')
        labelTxt2 = 'LCS';
    elseif strfind(lower(inputname(4)), 'amc')
        labelTxt2 = 'ASF/AMC';
    end
end

if nargin < 5
    recompute = false;
end

if nargin < 6
    b = length(motionClasses);
    m = floor(sqrt(b));
    
    if m*m ~= b
        m = m + 1;
    end
    
    n = double(int32(b/m));
    
    if mod(b,m)~=0
        n = n + 1;
    end
    
end

if nargin < 8
    tau1 = 0.02;
    tau2 = 1;
end

if recompute
    
    for i=1:length(motionClasses)
        motionClass = motionClasses{i};
        disp(motionClass);
%         
%         if i < 120
%             continue;
%         end
        
        idx1 = strmatch(motionClass, {results1.category}', 'exact');
        idx2 = strmatch(motionClass, {results2.category}', 'exact');
        
        if isempty(idx1) || isempty(idx2)
            error('Motion class not contained in results!');
        end
        
        hits1 = results1(idx1).hits;
        hits2 = results2(idx2).hits;
        
        %         hitIdx11 = find([hits1.cost] <= tau1);
        %         hitIdx21 = find([hits2.cost] <= tau1);
        %         hits11 = hits1(hitIdx11);
        %         hits21 = hits2(hitIdx21);
        hits11 = hits1(1:min(20, length(hits1)));
        hits21 = hits2(1:min(20, length(hits2)));
        
        if (~isempty(hits1) && ~isempty(hits2))
            hitIdx12 = find([hits1.cost] <= tau2);
            hitIdx22 = find([hits2.cost] <= tau2);
            
            hits12 = hits1(hitIdx12);
            hits22 = hits2(hitIdx22);
        else
            hits12 = [];
            hits22 = [];
        end
        
        [precision1{1,i}, recall1{1,i}, n_relevant1{1,i}] = precision_recall2(motionClass, hits11, false, DB_info);
        [precision1{2,i}, recall1{2,i}, n_relevant1{2,i}] = precision_recall2(motionClass, hits21, false, DB_info);
        
        [precision2{1,i}, recall2{1,i}, n_relevant2{1,i}] = precision_recall2(motionClass, hits12, false, DB_info);
        [precision2{2,i}, recall2{2,i}, n_relevant2{2,i}] = precision_recall2(motionClass, hits22, false, DB_info);
    end
    save(fullfile(fullPath, 'Cache', saveFileName), 'precision1', 'recall1', 'n_relevant1', 'precision2', 'recall2', 'n_relevant2');
    
else
    load(fullfile(fullPath, 'Cache', saveFileName));
end

figure;
lineColors = {[0 0 1], [1 0 0], [0 0 1], [1 0 0], [0.6 0.6 1], [1 0.6 0.6]};

for i=1:length(motionClasses)
    motionClass = motionClasses{i};
    
    h=subplot(m,n,i);
    set(h, 'ButtonDownFcn', {@onClick, motionClass, i });
    hold on;
    plot(recall2{1,i}, precision2{1,i}, 'g');
    plot(recall2{2,i}, precision2{2,i}, 'y');
    plot(recall1{1,i}, precision1{1,i}, 'g');
    plot(recall1{2,i}, precision1{2,i}, 'y');
    
    % delimiters of two tau-curves
    plot(recall1{1,i}(end), precision1{1,i}(end), 'gx');
    plot(recall1{2,i}(end), precision1{2,i}(end), 'yx');
    
    plotLines = get(gca, 'Children');
    for j=1:length(plotLines)
        set(plotLines(j), 'Color', lineColors{j});
    end
    
    %     % delimiters of Top20
    %     top = min(20, min(length(recall1{1,i}), length(recall1{2,i})));
    %     topX = recall1{1,i}(top) / max(recall1{1,i}(top), precision1{1,i}(top));
    %     topY = precision1{1,i}(top) / max(recall1{1,i}(top), precision1{1,i}(top));
    %     l = line([0 topX], [0 topY]);
    %     set(l, 'color', [0.6*ones(3,1)]);
    
    
    %     if length(motionClasses)==1
    %         plot(recall{1,i}, precision{1,i}, 'rx');
    %         plot(recall{2,i}, precision{2,i}, 'bx');
    %         xlabel('recall');
    %         ylabel('precision');
    %     end
    
    set(gca, 'XLim', [0 1.05]);
    set(gca, 'YLim', [0 1.05]);
    
    if length(motionClasses) < 5
        legend({labelTxt1, labelTxt2});
    else
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        
        t = text(0.5, -0.1, motionClass);
        set(t, 'horizontalalignment', 'center');
        set(t, 'FontSize', 6);
        
        %         t=title(motionClass);
        %         set(t, 'FontSize', 6);
        %         set(t, 'Position', [0.55 1.2 1])
    end
end


% ---------------------------------------------------
function onClick( src, eventdata, motionClass, number)
set(gcf, 'Name', [motionClass ' (Nr. ' num2str(number) ')']);
disp(motionClass);
