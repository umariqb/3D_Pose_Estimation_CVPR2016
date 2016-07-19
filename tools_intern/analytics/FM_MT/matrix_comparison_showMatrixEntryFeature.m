function [ output_args ] = matrix_comparison_showMatrixEntryFeature( src, eventdata, featureNr, motionClasses, dbName1, dbName2, constBoneLengths )

pointClicked = get(get(src, 'Parent'), 'CurrentPoint');
x = round(pointClicked(1,1));
y = round(pointClicked(1,2));

if x <= length(motionClasses) 
    
    motionClass = motionClasses{x};
    fileNumber  = y;
    
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
    fullFiles1 = strcat(mat2cell(repmat(dir1,maxFiles,1), ones(maxFiles,1)), {files1(1:maxFiles).name}');
    fullFiles2 = strcat(mat2cell(repmat(dir2,maxFiles,1), ones(maxFiles,1)), {files2(1:maxFiles).name}');
    
    t = get(gcf,'selectionType');
    if strcmpi(t, 'alt')    % right click
        if y <= maxFiles
            disp(files1(y).name);
            feature_comparison_adv(fullFiles1{y}, fullFiles2{y}, constBoneLengths);
            set(gcf, 'Position', [528   244   494   420]);
            showRealFeatureValues(fullFiles1{y}, fullFiles2{y}, featureNr);
            set(gcf, 'Position', [4   244   516   420]);
        end
    else
        if y <= maxFiles
            title(files1(y).name, 'Interpreter', 'none');
        end
    end
end
