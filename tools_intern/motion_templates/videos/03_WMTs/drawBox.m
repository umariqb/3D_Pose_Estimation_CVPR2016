function h_line = drawBox(fig,position,color)

figure(fig);
axes('Position',position,'color','none','visible','off');
h_line=line([0 1 1 0 0],[1 1 0 0 1],'color',[0 150 255]/255,'linewidth',7);
