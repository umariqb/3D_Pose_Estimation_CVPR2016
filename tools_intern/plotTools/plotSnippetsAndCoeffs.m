function plotSnippetsAndCoeffs(hit)

% tmp=hit.startFrames;
% tmp(2,:)=hit.endFrames-(tmp(1,:));
% tmp=[tmp [0;hit.orgNumFrames]];

YLabels{1,1}='dummy';
for i=1:hit.numHits
    contains=strfind(YLabels,hit.hitProperties{i}.motionClass{1});
    gra=0;
    for gr=1:size(contains,1)
        if      ~isempty(contains{gr}) && ...
                (length(YLabels{gr})==length(hit.hitProperties{i}.motionClass{1}))

            gra=gra + 1;

        end
    end
    if gra==0
        YLabels=[YLabels; hit.hitProperties{i}.motionClass{1}];
    end
end
YLabels{1}='Complete Motion';

% map=[1 1 1; 0.5 0 0];
% colormap(map);

figure;

gca=subplot(2,1,[1]);

% line([1 hit.orgNumFrames],[1 1],'linewidth',5);

for hitInd=1:hit.numHits
   contains=strfind(YLabels,hit.hitProperties{hitInd}.motionClass{1});
   pos=1;
   while isempty(contains{pos})
    pos=pos+1;
   end
   
   hand=line([hit.hitProperties{hitInd}.startFrame ...
              hit.hitProperties{hitInd}.endFrame], ...
             [pos pos], ...
              'linewidth',20, ...
              'color',[0.2 0.2 1]) ;
   set(hand, 'buttondownFcn', {@motionPlayerCallback2, ...
        hit.hitProperties{hitInd}.res.skel, ... 
        hit.hitProperties{hitInd}.res.origMotCut, ...
        hit.hitProperties{hitInd}.res.skel, ...
        hit.hitProperties{hitInd}.res.recMot});
          
end

hold on;
% for i=1:size(tmp,2)-1
%     colormap(map);
%     barh(i,tmp(1,i)+tmp(2,i),'stack','FaceColor','flat', ...
%          'BarWidth',0.7,'EdgeColor','flat', ...
%          'ButtonDownFcn',{@playResultOnClick, ...
%                             Tensor, ...
%                             hit.hitProperties{i}} ...
%          );
%      
% end

% colormap(map);
% barh(tmp','stack','FaceColor','flat', ...
%           'BarWidth',0.7,'EdgeColor','flat');
axis([0 hit.orgNumFrames 1.5 size(YLabels,1)+0.5]);
set(gca,'YTick',2:size(YLabels,1));
set(gca,'YTickLabel',YLabels(2:end,:));

set(gca,'XTick',1:100:hit.orgNumFrames);
set(gca,'XTickLabel',0:100:hit.orgNumFrames);
grid on;
set(gca,'Layer','top')

% 
% x2 = axes('Position',get(x1,'Position'),...
%            'XAxisLocation','top',...
%            'YAxisLocation','right',...
%            'Color','none',...
%            'XColor','k','YColor','k');
       
% set (x2 ,'YTick',1:hit.numHits+1);
% set (x2 ,'YTickLabel',YLabels2);

xlabel('Frames');
handTitle=title(hit.amc,'Interpreter','None');

set(handTitle, 'buttondownFcn', {@motionPlayerCallback3, ...
        hit.asf, ... 
        hit.amc});


hold off;

h2=subplot(2,1,[2]);

set(h2,'NextPlot','replacechildren')
set(h2,'ColorOrder',[1 0 0;0 1 0;0 0 1;0.5 0 0.5;0 0.5 0.5; 0.5 0.5 0]);
[numHits,coeffs,styleList]=countHitsPerFrameAndCoefs(hit);


% testcolors=lines(size(styleList,2));
testcolors=jet(size(styleList,2));
% testcolors=hot(size(styleList,2));
% testcolors=rand(size(styleList,2),3);
hold on;

for styleInd=1:size(styleList,2)
    plot(coeffs.(styleList{styleInd})','color',testcolors(styleInd,:),'linewidth',5);
    styleY=0.63-mod(styleInd,15)*0.02;
    styleX=0.0+floor(styleInd/15)*0.1;
    textH=annotation('textbox',[ styleX styleY  0.1 0.025]);
    set(textH,'color',testcolors(styleInd,:));
    set(textH,'string',styleList(styleInd));
    set(textH,'EdgeColor','none');
end
hold off;

% countline=0;
% for l1=1:hit.numHits
%         for l2=1:size(hit.hitProperties{l1}.styles,2)
%             colind=1;
%             while ~strcmp(styleList{colind},hit.hitProperties{l1}.styles{l2})
%                 colind=colind+1;
%             end
% 
%             countline=countline+1;
%             
%             
%             plot(coeffs(countline,:),'LineWidth',3,'color',testcolors(colind,:));
%         end
% end
% legend on;
% legend(styleList);
% figure;surf(coeffs);
axis([0 hit.orgNumFrames -0.2 1.2]);
set(h2,'XTick',1:100:hit.orgNumFrames);
set(h2,'XTickLabel',0:100:hit.orgNumFrames);
grid on;

% % h3=subplot(3,1,[3]);
% % resE=plotRecErrors(hit);
% % axis([0 hit.orgNumFrames 0 50]);
% % set(h3,'XTick',1:100:hit.orgNumFrames);
% % set(h3,'XTickLabel',0:100:hit.orgNumFrames);
% % grid on;

end

function motionPlayerCallback2(src, eventdata, skel1, mot1, skel2, mot2)
    motionplayer('skel',{skel1 skel2}, 'mot', {mot1 mot2});
end

function motionPlayerCallback3(src, eventdata, asf,amc)

    infos=fileparts(amc);
    [skel,mot]=readMocap(fullfile(infos,asf),amc);
    motionplayer('skel',{skel}, 'mot', {mot});
end