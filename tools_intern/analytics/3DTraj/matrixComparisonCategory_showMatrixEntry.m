function [ output_args ] = matrixComparisonCategory_showMatrixEntry( src, eventdata, compFunction, DB_name1, DB_name2, category, filenames1, filenames2)

jointNames = getAllJointNames;

pointClicked = get(get(src, 'Parent'), 'CurrentPoint');
x = round(pointClicked(1,1));
y = round(pointClicked(1,2));

if x <= length(filenames1) 
    filename1 = filenames1{ x };
    filename2 = filenames2{ x };
    
    % left click and right click: Change title to display information
    if y <= length(jointNames)
        jointName = jointNames{ y };
        title(filename1(1:end-4), 'Interpreter', 'none');

        % right click: Open up comparison for selected motion class
        t = get(gcf,'selectionType');
        
        if strcmpi(t, 'alt')    % right click
            global VARS_GLOBAL
            
            DB_path1 = fullfile( VARS_GLOBAL.dir_root, DB_name1, category );
            DB_path2 = fullfile( VARS_GLOBAL.dir_root, DB_name2, category );
            fullFile1 = fullfile(DB_path1, filename1);
            fullFile2 = fullfile(DB_path2, filename2);
            [skel1, mot1] = readMocapSmartLCS(fullFile1, true);
            [skel2, mot2] = readMocapSmartLCS(fullFile2, true);
            
            disp(['[skel1, mot1] = readMocapSmart(''' fullFile1 ''');']);
            disp(['[skel2, mot2] = readMocapSmart(''' fullFile2 ''');']);
            compareJoint(skel1, mot1, skel2, mot2, jointName);
        end    
        
    else
        title(filename1(1:end-4), 'Interpreter', 'none');
    end
    
    
else
    if y <= length(jointNames)
        jointName = jointNames{ y };
        title(jointName, 'Interpreter', 'none');
    else
        title('CLICK IMAGE FOR DETAILS!', 'Interpreter', 'none');
    end
end
