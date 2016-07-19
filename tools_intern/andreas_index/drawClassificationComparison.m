function drawClassificationComparison(DB_concat, classificationResult, manualClassificationResult, documents, classesPerDocument, parameter)
%DRAWCLASSIFICATIONRESULT this function draws figures that compare the
%manual classification to the automatic classification.
%   DB_concat: Database description optained by DB_index_load
%   classificationResult: 
%   manualClassificationResult:
%   documens: 1xD vector containing the indices of the documents in
%   DB_concat for which a figure should be drawn.
%   classesPerDocument: 1xD cell array. The d-th entry is a cell array
%   containing the names of the classes that should be considered in the
%   figure of the d-th document
%   parameter.countingPR =[]: set this to the countingPR cost measure
%       calculated by evaluateClassification if you want these values to be
%       visualized for each drawn document.
%   parameter.framewisePR =[]: set this to the framewisePR cost measure
%       calculated by evaluateClassification if you want these values to be
%       visualized for each drawn document.
%   parameter.printFigure 
%   parameter.filenamePrefix
%   parameter.paperPosition
%   parameter.omitTitle
%
%   parameter.delta:                % include the delta and
%   parameter.classificationDelta:  % classificationDelta functions and the
%   parameter.motion_classes = {};  % motion classes names that correspond to 
%       each line in the delta and cDelta if you want the deltas to be shown 
%       when right klicking on the title of the figure.
%   

if isfield(parameter, 'printFigure') == 0
    parameter.printFigure = 0;
end
if isfield(parameter, 'filenamePrefix') == 0
    parameter.filenamePrefix = 'figures/classificationComparison_constantThreshold_0.1_';
end
if isfield(parameter, 'paperPosition') == 0
    parameter.paperPosition = [1,1,6.3,2.5];

end
if isfield(parameter, 'omitTitle') == 0
    parameter.omitTitle = 0;
end

if isfield(parameter,'countingPR')==0
   parameter.countingPR = [];
end
if isfield(parameter,'framewisePR')==0
   parameter.framewisePR = [];
end

if isfield(parameter,'delta')==0
   parameter.delta = [];
end
if isfield(parameter,'classificationDelta')==0
   parameter.classificationDelta = [];
end
if isfield(parameter,'classificationDelta')==0
   parameter.motion_classes = {};
end




global VARS_GLOBAL;
for d=1:length(documents)
    currentDocument = documents(d);
    docName = DB_concat.files_name{currentDocument};
    idx = strfind(docName, filesep);
    docShortName = docName((idx(end)+1):end-4);
    
    
    
    docLength = DB_concat.files_frame_length(currentDocument);
    classes = classesPerDocument{d};
    
    figure;
    if parameter.omitTitle == 0
        t=title(docName, 'interpreter', 'none');
        filename = fullfile(VARS_GLOBAL.dir_root, docName);
        [info, ok] = filename2info(filename);
        if ok
            [skel,mot] = readMocap(fullfile(info.amcpath, info.asfname), fullfile(info.amcpath, info.amcname));
            set(t, 'buttondownFcn', {@motionPlayerCallback, skel,mot, currentDocument});
        end
    end

    set(gca, 'xlim', [1, docLength]);
    set(gca, 'ylim', [0.5, length(classes)*2+0.5]);

    
%     yticklabels = cell(1,2*length(classes));
%     yticklabels(1:2:2*length(classes)) = classes;
%     
%     yticklabels(2:2:2*length(classes)) = repmat({'manual'}, 1, length(classes));
% 
%     idx = strmatch('walk2StepsLstart_walk2StepsRstart', yticklabels);
%     if ~isempty(idx)
%         yticklabels(idx) = repmat({'walk'}, 1, length(idx));
%     end
%     
%     set(gca, 'ytick', 1:2*length(classes));
%     set(gca, 'yticklabel', yticklabels);
    
    % draw class labels inbetween two rows
    yticklabel = classes;
    idx = strmatch('walk2StepsLstart_walk2StepsRstart', yticklabel);
    if ~isempty(idx)
        yticklabel(idx) = repmat({'walk'}, 1, length(idx));
    end
    idx = strmatch('standStill500', yticklabel);
    if ~isempty(idx)
        yticklabel(idx) = repmat({'neutral'}, 1, length(idx));
    end
    idx = strmatch('lying', yticklabel);
    if ~isempty(idx)
        yticklabel(idx) = repmat({'lie'}, 1, length(idx));
    end

    set(gca, 'ytick', [1.5:2:2*length(classes)]);
    set(gca, 'yticklabel', yticklabel);
    
    
    
    for c=1:length(classes)
        class = classes{c};
        
        % draw a line that separates the classes in the figure
        line([1, docLength], [2*c+0.5, 2*c+0.5]);
        
        % find out all hits of the current document belonging to the
        % current class (using classificationResult)
        hitData = classificationResult.(class)((classificationResult.(class)(:,1) == currentDocument), [2:3, 6]);
        for h=1:size(hitData, 1)
            hitStart = hitData(h, 1);
            hitEnd = hitData(h, 2);
            cost = hitData(h, 3);

            % remap from 30Hz to 120 Hz
            animationStart = hitStart * 4 - 4 + 1;
            animationEnd = hitEnd * 4 - 4 + 1;
        
            %draw rectangle
            color = [1 0 0]; %[0 127 14]/255;
            yPosition = 2*c - 1;
            
            hitWidth = hitStart-hitEnd;
            if hitWidth == 0
                handle = line([hitStart, hitStart], [yPosition-0.3, yPosition+0.3], 'Color', [0,0,0], 'LineWidth', 1);
            else
            
            
                handle = rectangle('Position', [hitStart, yPosition-0.3,...
                    hitEnd - hitStart+1, 0.6],...
                    'EdgeColor', [0 0 0],...
                    'FaceColor', color,...
                    'LineWidth', 0.1);
            end
            set(handle,'ButtonDownFcn',{@animateRectOnClick,...
                                        docName,...
                                        animationStart,...
                                        animationEnd, ...
                                        cost,...
                                        hitStart,...
                                        hitEnd,...
                                      });
            
        end

        set(gcf, 'name', [docShortName]);
        set(gcf, 'position', [ 1601         -79        1000        440]);
           
        % now draw all manual classifications
        % find out which struct of the manualClassificationResult fits to
        % the current document
        idx = strmatch(docName, {manualClassificationResult.filename});
        if length(idx) < 1 
            disp(['No manual classifications found for the file ' docName '.']); 
            continue;
        end
        if length(idx) > 1
            error(['More than one manual classification has been found for document ' docName '.']);
        end
        
        if ~isfield(manualClassificationResult(idx).classInfo, class)
            disp(['Manual annotation of class ' class ' not found for document ' docName]);
            continue;
        end
        hitData = manualClassificationResult(idx).classification{manualClassificationResult(idx).classInfo.(class)};
        %remap from 120 Hz to 30 Hz
        if ~isempty(hitData)
            hitData(:, 1:2) = ceil(hitData(:, 1:2)/4);
        end
        
        
        
        for h=1:size(hitData, 1)
            hitStart = hitData(h, 1);
            hitEnd = hitData(h, 2);
            cost = 0;

            
            
            % remap from 30Hz to 120 Hz
            animationStart = hitStart * 4 - 4 + 1;
            animationEnd = hitEnd * 4 - 4 + 1;
        
            %draw rectangle
            color = [0 0 0];
            yPosition = 2*c;
            hitWidth = hitStart-hitEnd;
            if hitWidth == 0
                handle = line([hitStart, hitStart], [yPosition-0.3, yPosition+0.3], 'Color', [0,0,0], 'LineWidth', 1);
            else
            
                handle = rectangle('Position', [hitStart, yPosition-0.3,...
                    hitEnd - hitStart+1, 0.6],...
                    'EdgeColor',  color, ... %[0 127 14]/255,...
                    'FaceColor', color,...
                    'LineWidth', 0.1);
            end
            set(handle,'ButtonDownFcn',{@animateRectOnClick,...
                                        docName,...
                                        animationStart,...
                                        animationEnd, ...
                                        cost,...
                                        hitStart,...
                                        hitEnd,...
                                      });
        end  
        
        % draw the box around the figure manually to avoid the tickmarks on
        % the right with the command 'box on'
        line([docLength, docLength], [0.5, 2*length(classes)+0.5], 'Color', [0,0,0]);
        line([1, docLength], [2*length(classes)+0.5, 2*length(classes)+0.5], 'Color', [0,0,0]);        

        if ~isempty(parameter.countingPR)
            textString = sprintf('Counting P: %1.2f  R: %1.2f', parameter.countingPR(currentDocument, 1), parameter.countingPR(currentDocument, 2));
            text(1, -1.5 , textString);
        end
            
        if ~isempty(parameter.framewisePR)
            textString = sprintf('Framewise P: %1.2f  R: %1.2f', parameter.framewisePR(currentDocument, 1), parameter.framewisePR(currentDocument, 2));
            text(docLength/2, -1.5, textString);
        end
    end
    if parameter.printFigure
        set(gcf, 'paperPosition', parameter.paperPosition);
        filename =  [parameter.filenamePrefix docShortName '.eps'];
%         filename =  ['figures/classificationComparison_classDependentThreshold_' docShortName '.eps'];
        print('-depsc2', filename);
    end
    
%     filename =  ['figures/' docShortName '.fig'];
%     saveas(gcf,filename);

end
    function motionPlayerCallback(src, eventdata, skel, mot, document)
        t = get(gcf,'selectionType');
        switch t
            %%%%%%%%%% left click %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%% play the document in the motion player%%%%%%%%%%%%%%%%%%%%%%
            case 'normal'
                motionplayer('skel',{skel}, 'mot', {mot});
            %%%%%%%%%% right click %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%% show the deltas and classification deltas %%%%%%%%%%%%%%%%%%%            
            case 'alt'
                if ~isempty(parameter.delta) && ~isempty(parameter.classificationDelta) && ~isempty(parameter.motion_classes)         
                
                    parameter.manualClassificationResult = manualClassificationResult; 
                    parameter.cmap = hot(64);
                    parameter.cAxisLimits = [0, 0.2];

                    parameter.deltaAll = 0;
                    parameter.deltaSuper = 0;
                    parameter.cdeltaAll = 1;
                    parameter.cdeltaSuper = 1;
                    parameter.superClassOrder = parameter.superclasses;
                    drawAnnotationDeltas(DB_concat, document, parameter.motion_classes, parameter.delta, parameter.classificationDelta, parameter);                
                end
                
            %%%%%%%%%% shift click %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%% draw the features %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            case 'extend'
                drawFeaturesForDatabaseDocument( DB_concat, document)
                
                
        end
    end
end %function       
        
    

