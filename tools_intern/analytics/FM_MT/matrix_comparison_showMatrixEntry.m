function [ output_args ] = matrix_comparison_showMatrixEntry( src, eventdata, featureNames, motionClass, files1, files2 )

pointClicked = get(get(src, 'Parent'), 'CurrentPoint');
x = round(pointClicked(1,1));
y = round(pointClicked(1,2));

if x <= length(files1) 
   
    % left click and right click: Change title to display information
    info = filename2info(files1{x});
    set(get(get(src, 'Parent'), 'Title'), 'String', info.amcname);
    set(get(get(src, 'Parent'), 'Title'), 'Interpreter', 'none');
    
    % right click: Open up comparison for selected motion class
    t = get(gcf,'selectionType');
    if strcmpi(t, 'alt')    % right click
        
        feature_comparison_adv(files1{x}, files2{x});
        set(gcf, 'Position', [528   244   494   420]);
        showRealFeatureValues(files1{x}, files2{x}, y);
        set(gcf, 'Position', [4   244   516   420]);
    end    
else
    if y <= length(featureNames)
        featureName = featureNames{ y };
        set(get(get(src, 'Parent'), 'Title'), 'String', featureName);
    else
        set(get(get(src, 'Parent'), 'Title'), 'String', 'CLICK IMAGE FOR DETAILS!');
    end
end
