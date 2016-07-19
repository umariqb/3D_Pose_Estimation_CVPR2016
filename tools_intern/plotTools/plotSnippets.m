function plotSnippets(hit)

tmp=hit.startFrames;
tmp(2,:)=hit.endFrames-(tmp(1,:));
tmp=[tmp [0;hit.orgNumFrames]];

YLabels=cell(hit.numHits+1);
for i=1:hit.numHits
   YLabels{i} = hit.hitProperties{i}.motionClass;
end
YLabels{hit.numHits+1}='Complete Motion';

map=[1 1 1; 0.5 0 0];
% colormap(map);

figure;

subplot(3,1,[1 2]);

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

colormap(map);
barh(tmp','stack','FaceColor','flat', ...
          'BarWidth',0.7,'EdgeColor','flat');
axis([0 hit.orgNumFrames 0.5 hit.numHits+1.5]);
set(gca,'YTick',1:hit.numHits+1);
set(gca,'YTickLabel',YLabels);

set(gca,'XTick',1:50:hit.orgNumFrames);
set(gca,'XTickLabel',0:50:hit.orgNumFrames);
grid on;
set(gca,'Layer','top')

xlabel('Frames');
title(hit.amc,'Interpreter','None');

hold off;

h2=subplot(3,1,3);
numHits=countHitsPerFrame(hit);
bar(numHits,1,'EdgeColor','flat');
axis([0 hit.orgNumFrames 0 max(numHits)]);
set(h2,'color',[0.5 0 0])

