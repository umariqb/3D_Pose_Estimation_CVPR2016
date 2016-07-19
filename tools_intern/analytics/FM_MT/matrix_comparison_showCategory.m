function [ output_args ] = matrix_comparison_showCategory( src, eventdata, compFunction, diffPerFeature, featureNames, motionClasses, dbName1, dbName2, CLIM )

pointClicked = get(get(src, 'Parent'), 'CurrentPoint');
x = round(pointClicked(1,1));
y = round(pointClicked(1,2));

if x <= length(motionClasses) 
    motionClass = motionClasses{ x };
    
    % left click and right click: Change title to display information
    if y <= length(featureNames)
        featureName = featureNames{ y };
        t = title([featureName ' - ' motionClass]);
        set(t, 'Interpreter', 'none');
    else
        t = title(motionClass);
        set(t, 'Interpreter', 'none');
    end
    
    disp(get(get(gca, 'title'), 'string'));
    
    % right click: Open up comparison for selected motion class
    t = get(gcf,'selectionType');
    if strcmpi(t, 'alt')    % right click
        
        motionClass = motionClasses{x};
%         showTemplateComparison(motionClass);
        
        dir1 = fullfile(dbName1, motionClass, filesep);
        files1 = dir(fullfile(dir1, '*.c3d'));
        dir2 = fullfile(dbName2, motionClass, filesep);
        files2 = dir(fullfile(dir2, '*.c3d'));
        
        if isempty(files1)  % db1 is AMC, db2 is C3D
            files1 = dir(fullfile(dir1, '*.amc'));
        else                % db1 is C3D, db2 is AMC
            files2 = dir(fullfile(dir2, '*.amc'));
        end
        maxFiles = min([length(files1) length(files2)]);
        files1 = strcat(mat2cell(repmat(dir1,maxFiles,1), ones(maxFiles,1)), {files1(1:maxFiles).name}');
        files2 = strcat(mat2cell(repmat(dir2,maxFiles,1), ones(maxFiles,1)), {files2(1:maxFiles).name}');
        
        
        figure;
        if nargin < 10 || isempty(CLIM)
            imagesc(diffPerFeature{x});
        else
            imagesc(diffPerFeature{x}, CLIM);
        end
        set(get(gca, 'Children'), 'buttondownfcn',{@matrix_comparison_showMatrixEntry, featureNames, motionClass, files1, files2 });
        
        axis off;
        
        colormap('hot');
        set(gca, 'Position', [0.25 0.11 0.72 0.85]);
        
        h = text(floor(length(files1)/2), length(featureNames)+2, ['files in motion class ' motionClass]);
        set(h, 'HorizontalAlignment', 'Center');
        for i=1:length(featureNames)
            h = text(0, i, featureNames{i}(17:end-7));
            set(h, 'HorizontalAlignment', 'Right');
            set(h, 'Interpreter', 'None');
            set(h, 'FontSize', 8);
            set(h, 'ButtonDownFcn', @featureTextOnClick);
        end
        set(gcf, 'Position', [373    58   650   631]);
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

t = get(gcf,'selectionType');
if strcmpi(t, 'alt')    % right click
    fullFeatureName = ['feature_AK_bool_' get(src, 'String') '_robust'];
    open(fullFeatureName);
else
    disp(get(src, 'String'));
end
