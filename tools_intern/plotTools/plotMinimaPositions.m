function plotMinimaPositions(Data)

figure;
dim=size(Data);

imagesc(Data');
colorbar;
colormap hot;
hold on;


% min=imregionalmin(Data);
% 
% % [r lists] = sort(Data,1);
% 
% 
% tresh=max(Data(:))/40;
% 
% for i=1:dim(1)
%     for j=1:dim(1)
%         if((min(i,j)==1)&&(Data(i,j)<tresh))
%             plot(i,j,'.','color',[0,1,0])
%         end
%     end
% end