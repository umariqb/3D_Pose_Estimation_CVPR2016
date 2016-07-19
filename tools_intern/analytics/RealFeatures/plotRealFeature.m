function plotRealFeature(Data,Labels)

figure;
imagesc(Data');
colormap hot;
set(gca,'YTickLabel',Labels);
set(gca,'YTick',1:size(Labels'));
set(gca,'FontSize',9);
colorbar;
