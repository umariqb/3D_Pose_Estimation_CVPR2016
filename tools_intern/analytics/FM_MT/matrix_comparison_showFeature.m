function matrix = matrix_comparison_showFeature( src, eventdata, compFunction, diffPerFeature, featureNames, motionClasses, dbName1, dbName2, constBoneLengths, CLIM  )

pointClicked = get(get(src, 'Parent'), 'CurrentPoint');
x = round(pointClicked(1,1));
y = round(pointClicked(1,2));

% cmap = hot;
% cmap(1,:) = [0.4 0.4 0.4];  % for not used entries

if x <= length(motionClasses) 
    motionClass = motionClasses{ x };
    
    % left click and right click: Change title to display information
    if y <= length(featureNames)
        featureName = featureNames{ y };
        set(get(get(src, 'Parent'), 'Title'), 'String', [featureName ' (Nr. ' num2str(y) ')      -      ' motionClass]);
        set(get(get(src, 'Parent'), 'Title'), 'Interpreter', 'none');
    end

    disp(get(get(gca, 'title'), 'string'));

    % right click: Open up comparison for selected motion class
    t = get(gcf,'selectionType');
    if strcmpi(t, 'alt')    % right click
        
%         matrix = zeros(length(featureNames), length(motionClasses));
        for i=1:length(motionClasses)
            matrix(1:length(diffPerFeature{i}(y,:)),i) = diffPerFeature{i}(y,:)';
        end
        
        figure;
%         imagesc(matrix, 'buttondownfcn',{@matrix_comparison_showMatrixEntryFeature, y, motionClasses, dbName1, dbName2, constBoneLengths });
        if nargin < 10 || isempty(CLIM)
            imagesc(matrix);
        else
            imagesc(matrix, CLIM);
        end
        set(get(gca, 'Children'), 'buttondownfcn',{@matrix_comparison_showMatrixEntryFeature, y, motionClasses, dbName1, dbName2, constBoneLengths });

        axis off;
        colormap('hot');
        
        for i=1:length(motionClasses)
            rectY = length(diffPerFeature{i}(y,:));
            rectHeight = size(matrix, 2) - rectY;
%             if rectHeight > 0
            h=rectangle('Position', [i-0.5 rectY+0.5 1.02 rectHeight]);
            set(h, 'EdgeColor', 'none');
            set(h, 'FaceColor', [0.5 0.5 0.5]);
            
            for j=1:rectHeight
                h=line([i-0.5 i+0.5], [rectY-0.5+j rectY+0.505+j]);
                set(h, 'Color', [0 0 0]);
                set(h, 'LineWidth', 0.2);
            end
        end
        
        set(gcf, 'Name', [featureName ' (Nr. ' num2str(y) ')']);
        
        h = text(-1, floor(size(matrix,1)/2), 'files in motion class');
        set(h, 'HorizontalAlignment', 'Center');
        set(h, 'Rotation', 90);
        set(h, 'FontSize', 8);
        
        for i=1:length(motionClasses)
            h = text(i, size(matrix, 1)+1.5, motionClasses{i});
            set(h, 'HorizontalAlignment', 'Right');
            set(h, 'Rotation', 55);
            set(h, 'FontSize', 5);
        end
        
        set(gca, 'Position', [0.07 0.155 0.92 0.8]);
        set(gcf, 'Position', [4    57   831   646]);
    end    
else
    if y <= length(featureNames)
        featureName = featureNames{ y };
        set(get(get(src, 'Parent'), 'Title'), 'String', featureName);
    else
        set(get(get(src, 'Parent'), 'Title'), 'String', 'CLICK IMAGE FOR DETAILS!');
    end
end

% -----------------------------------------------------------
function featureTextOnClick(src, eventdata)
fullFeatureName = ['feature_AK_bool_' get(src, 'String') '_robust'];
open(fullFeatureName);
