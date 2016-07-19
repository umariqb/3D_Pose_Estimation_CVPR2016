function plotRealFeatureMultipleFeatures(ALL)

figure;
dims=size(ALL);
for i=1:dims(2)
    subplot(dims(2),dims(1),i);
    imagesc(ALL{i}{1}');
    if min(min(ALL{i}{1}))<0
        colormap Jet;
    else
        colormap Hot;
    end
    d=size(ALL{i});
    if(d(2)>1)
        set(gca,'YTickLabel',ALL{i}{2});
        set(gca,'YTick',1:size(ALL{i}{2}'));
    end
    set(gca,'FontSize',10/dims(2)+2);
    colorbar;
end
