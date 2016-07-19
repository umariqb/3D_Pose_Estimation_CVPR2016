function barSlide(data)

    numBars = size(data,2);
%     numDims = size(data,1);
    
%     c_lo = 4;
%     c_up = 12;
%     c_in = c_up - c_lo;
    
    bw = 0.4;
    
    hand = figure();
    
%     cmap = colormap(jet(128));
    hold all;
    plot(data(1,:),'*','color','blue','linewidth',3);
    plot(data(1,:),'--','color','blue');
    plot(data(2,:),'*','color','green','linewidth',3);
    plot(data(2,:),'--','color','green');

% %     for i = 1:numBars
% %     
% % %         col1 = cmap( floor((data(1,i)-c_lo)/( c_in / 127))+1,:);
% % %         col2 = cmap( floor((data(2,i)-c_lo)/( c_in / 127))+1,:);
% %         
% % %         rectangle('Position', [i-bw,0,bw,data(1,i)], ...
% % %                   'FaceColor', 'green');%col1);
% %           line ([i-bw i+bw],[data(1,i) data(1,i)], ...
% %                 'color','green', ...
% %                 'linewidth',2);
% % 
% % %         rectangle('Position', [i,0,bw,data(2,i)], ...
% % %                   'FaceColor', 'blue');%col2);
% % 
% %            line ([i-bw i+bw],[data(2,i) data(2,i)], ...
% %                 'color','blue', ...
% %                 'linewidth',2);
% %         
% %     end
    
    grid on
    
    axis([0 numBars+1 0 10]);
    ylabel('average reconstruction error');
    xlabel('motion id')
    
    set(gca,'xtick',1:numBars);

    diff = abs(data(1,:)-data(2,:));
    d    = diff./data(2,:);
    
    ax2 = axes('Position',get(gca,'Position'),...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','black','YColor','red');
       %            'XAxisLocation','top',...
    axis([0 numBars+1 0 1])
    ylabel('relative difference')
    hold all
    plot(d,'*','color','red','linewidth',3);
    plot(d,'--','color','red'); 
    
%     for i=1:numBars
%        
%         line([i-bw i+bw],[d(i) d(i)],'color','red','linewidth',2 );
%         
%     end

end