function plotMultiLayerResult2Fig(annotation,hits4File, parameter)

if nargin < 3
    parameter = struct;
end

if isfield(parameter, 'printFigure') == 0
    parameter.printFigure = 0;
end
if isfield(parameter, 'filenamePrefix') == 0
    parameter.filenamePrefix = 'figures/tensorClassification_';
end
if isfield(parameter, 'paperPositionClassification') == 0
    parameter.paperPositionClassification = [1,1,6.3,2.5];

end
if isfield(parameter, 'paperPositionPartDTW') == 0
    parameter.paperPositionPartDTW = [1,1,6.3,2.5];

end

if isfield(parameter, 'omitTitle') == 0
    parameter.omitTitle = 0;
end

global VARS_GLOBAL;

motClasses = flipud(fieldnames(annotation));

document=hits4File.amc;
docLength = hits4File.orgNumFrames;
figure();
set(gcf, 'renderer', 'painters') ;
set(gcf, 'name', [document]);
[temp, docShortName] = fileparts(document);

set(gcf, 'position',[50 50 1000 440]);

%% Collect Annotations for document.

% hitData = classificationResult.(class)((classificationResult.(class)(:,1) == currentDocument), [2:3, 6]);
% h1=subplot(2,1,1);
if parameter.omitTitle == 0
    handle=title(document,'interpreter','none');
    set(handle,'ButtonDownFcn',{@motionPlayerCallbackLoad, hits4File.amc,1,hits4File.orgNumFrames*4});
end

set(gca, 'ytick', [1.5:2:length(motClasses)*2]);
set(gca, 'yticklabel', motClasses);
% set(gca, 'XTick',1:100:hits4File.orgNumFrames);
% set(gca, 'XTickLabel',0:100:hits4File.orgNumFrames);

axis([0 hits4File.orgNumFrames 0.5 length(motClasses)*2+0.5]);

for mClass=1:size(motClasses,1);
    
    line([1, hits4File.orgNumFrames], [2*mClass+0.5, 2*mClass+0.5]);
    
    hitData=zeros(1,2);
    count=1;
    if ~isempty(annotation.(motClasses{mClass}))
        for i=1:size(annotation.(motClasses{mClass}),1);
            if strcmp(strcat(VARS_GLOBAL.dir_root,annotation.(motClasses{mClass})(i,3)),document)
                hitData(count,:)=cell2mat(annotation.(motClasses{mClass})(i,1:2));
                files{count}=annotation.(motClasses{mClass})(i,3);
                count=count+1;
            end
        end
    end
    
    for h=1:size(hitData, 1)
            hitStart = hitData(h, 1);
            hitEnd = hitData(h, 2);

            % remap from 30Hz to 120 Hz
%             animationStart = hitStart * 4 - 4 + 1;
%             animationEnd = hitEnd * 4 - 4 + 1;
        
            %draw rectangle
            color = [1 0 0]; %[0 127 14]/255;
            yPosition = mClass*2;
            
            hitWidth = hitStart-hitEnd;
            if hitWidth == 0
                handle = line([hitStart, hitStart], [yPosition-0.3, yPosition+0.3], 'Color', [0,0,0], 'LineWidth', 1);
            else
            
            
                handle = rectangle('Position', [hitStart, yPosition-0.3,...
                    hitEnd - hitStart+1, 0.6],...
                    'EdgeColor', [0 0 0],...
                    'FaceColor', color,...
                    'LineWidth', 0.1);
                
                set(handle,'ButtonDownFcn',{@motionPlayerCallbackLoad, fullfile(VARS_GLOBAL.dir_root,cell2mat(files{h})),hitData(h,1)*4,hitData(h,2)*4});
                
                
            end
%             set(handle,'ButtonDownFcn',{@animateRectOnClick,...
%                                         docName,...
%                                         animationStart,...
%                                         animationEnd, ...
%                                         cost,...
%                                         hitStart,...
%                                         hitEnd,...
%                                       });
            
    end     
end

for hit=1:hits4File.numHits
    mClassStr = hits4File.hitProperties{1,hit}.motionClass;
    tmp=strfind(motClasses,cell2mat(mClassStr));
    mClass=1;
    while isempty(cell2mat(tmp(mClass)))
        mClass=mClass+1;
    end
    hitStart=hits4File.startFrames(hit);
    hitEnd  =hits4File.endFrames  (hit);
    color = [0 0.7 0];
    yPosition = 2*mClass-1;
    hitWidth = hitStart-hitEnd;
    if hitWidth == 0
        handle = line([hitStart, hitStart], [yPosition-0.3, yPosition+0.3], 'Color', [0,0,0], 'LineWidth', 1);
    else
        handle = rectangle('Position', [hitStart, yPosition-0.3,...
            hitEnd - hitStart+1, 0.6],...
            'EdgeColor', [0 0 0],...
            'FaceColor', color,...
            'LineWidth', 0.1);
        set(handle,'ButtonDownFcn',{@motionPlayerCallback1, ...
                   hits4File.hitProperties{1,hit}.res.skel, ...
                   hits4File.hitProperties{1,hit}.orgMot});
    end
    
end
    line([docLength, docLength], [0.5, 2*length(motClasses)+0.5], 'Color', [0,0,0]);
    line([1, docLength], [2*length(motClasses)+0.5, 2*length(motClasses)+0.5], 'Color', [0,0,0]);        

    if parameter.printFigure
        set(gcf, 'paperPosition', parameter.paperPositionPartDTW);
        filename =  [parameter.filenamePrefix '_PartDTW_' docShortName '.eps'];
        print('-depsc2', filename);
    end

    



%% Collect PartDTW Hits for Document!

figure();
set(gcf, 'renderer', 'painters') ;
set(gcf, 'name', [document]);
set(gcf, 'position',[50 500 1000 440]);
if parameter.omitTitle == 0
    handle=title(document,'interpreter','none');
end

%create styleList

[numHits,coeffs,styleList]=countHitsPerFrameAndCoefs(hits4File);

ylabels = renameSubclasses(styleList);

set(gca, 'ytick', 1:1:size(styleList,2));
set(gca, 'yticklabel', ylabels);
% set(gca, 'XTick',1:100:hits4File.orgNumFrames);
% set(gca, 'XTickLabel',0:100:hits4File.orgNumFrames);

for styInd=1:size(styleList,2)
    line([1, hits4File.orgNumFrames], [styInd+0.5, styInd+0.5]);
end

axis([0 hits4File.orgNumFrames 0.5 size(styleList,2)+0.5]);

for hit=1:hits4File.numHits
   
   [maxval,maxPos]=max(hits4File.hitProperties{1,hit}.res.coeffsX{1});
   subClass=hits4File.hitProperties{1,hit}.styles{maxPos};
   
   tmp=strfind(styleList,subClass);
   mClass=1;
    while isempty(cell2mat(tmp(mClass)))
        mClass=mClass+1;
    end
   
   hitStart=hits4File.startFrames(hit);
    hitEnd  =hits4File.endFrames  (hit);
    if maxval>0.0
        color=[0 0.7 0];
    else
        color=[0 1 0];
    end
    yPosition = mClass;
    hitWidth = hitStart-hitEnd;
    if hitWidth == 0
        handle = line([hitStart, hitStart], [yPosition-0.3, yPosition+0.3], 'Color', [0,0,0], 'LineWidth', 1);
    else
        handle = rectangle('Position', [hitStart, yPosition-0.3,...
            hitEnd - hitStart+1, 0.6],...
            'EdgeColor', [0 0 0],...
            'FaceColor', color,...
            'LineWidth', 0.1);
         set(handle,'ButtonDownFcn',{@motionPlayerCallback2, ...
                   hits4File.hitProperties{1,hit}.res.skel, ...
                   hits4File.hitProperties{1,hit}.orgMot, ...
                   hits4File.hitProperties{1,hit}.res.skel, ...
                   hits4File.hitProperties{1,hit}.recMotUnWarp});
    end
    
end

    line([docLength, docLength], [0.5, 2*length(motClasses)+0.5], 'Color', [0,0,0]);
    line([1, docLength], [length(styleList)+0.5, length(styleList)+0.5], 'Color', [0,0,0]);        
 
if parameter.printFigure
    set(gcf, 'paperPosition', parameter.paperPositionClassification);
    filename =  [parameter.filenamePrefix '_Classification_' docShortName '.eps'];
    print('-depsc2', filename);
end


end


function motionPlayerCallback1(src, eventdata, skel1, mot1)
    motionplayer('skel',{skel1}, 'mot', {mot1});
end

function motionPlayerCallback2(src, eventdata, skel1, mot1, skel2, mot2)
    motionplayer('skel',{skel1 skel2}, 'mot', {mot1 mot2});
end

function motionPlayerCallbackLoad(src, eventdata, amc, startF, endF)
    infos=filename2info(amc);
    [skel,mot]   =readMocap(fullfile(infos.amcpath,infos.asfname),amc);
    mot=cutMotion(mot,startF,endF);
    motionplayer('skel',{skel}, 'mot', {mot});
    
end