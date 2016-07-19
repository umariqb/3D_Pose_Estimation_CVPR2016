function [ output_args ] = matrixComparison_showMatrixEntry( src, eventdata, compFunction, db1, db2, motion_classes)

jointNames = getAllJointNames;

showRect = false;

pointClicked = get(get(src, 'Parent'), 'CurrentPoint');
x = round(pointClicked(1,1));
y = round(pointClicked(1,2));

if x <= length(motion_classes) 
    motionClass = motion_classes{ x };
    
    % left click and right click: Change title to display information
    if y <= length(jointNames)
        jointName = jointNames{ y };
        title([jointName ', ' motionClass]);
        
        % delete old rectangles
        if showRect
            children=get(gca, 'Children');
            for k=1:length(children)
                if strcmpi(get(children(k), 'type'), 'rectangle')
                    delete(children(k));
                end
            end
            rect = rectangle('Position', [x-0.5 0.5 1 24]);
            set(rect, 'EdgeColor', [0 0 1]);
            set(rect, 'LineWidth', 1.5);
        end
    else
        title(motionClass);
    end
    

    % right click: Open up comparison for selected motion class
    t = get(gcf,'selectionType');

    if strcmpi(t, 'alt')    % right click
        matrixComparisonCategory(compFunction, db1, db2, motionClass, false);
    end    
else
    if y <= length(jointNames)
        jointName = jointNames{ y };
        title(jointName);
    else
        title('CLICK IMAGE FOR DETAILS!');
    end
end
