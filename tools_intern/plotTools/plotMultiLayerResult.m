function plotMultiLayerResult(annotation,hits4File)

global VARS_GLOBAL;

motClasses = fieldnames(annotation);

document=hits4File.amc;

figure;
set(gcf, 'renderer', 'painters') ;
set(gcf, 'name', [document]);

%% Collect Annotations for document.

% hitData = classificationResult.(class)((classificationResult.(class)(:,1) == currentDocument), [2:3, 6]);
h1=subplot(2,1,1);

handle=title(document,'interpreter','none');
set(handle,'ButtonDownFcn',{@motionPlayerCallbackLoad, hits4File.amc,1,hits4File.orgNumFrames*4});

set(h1, 'ytick', [1.5:2:length(motClasses)*2]);
set(h1, 'yticklabel', motClasses);
set(h1, 'XTick',1:100:hits4File.orgNumFrames);
set(h1, 'XTickLabel',0:100:hits4File.orgNumFrames);

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


%% Collect PartDTW Hits for Document!

h2=subplot(2,1,2);

%create styleList

[numHits,coeffs,styleList]=countHitsPerFrameAndCoefs(hits4File);

set(h2, 'ytick', 1:1:size(styleList,2));
set(h2, 'yticklabel', styleList);
set(h2, 'XTick',1:100:hits4File.orgNumFrames);
set(h2, 'XTickLabel',0:100:hits4File.orgNumFrames);

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



