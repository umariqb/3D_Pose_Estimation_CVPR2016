function plotDTWPaths(Data,Paths)

    figure;

    imagesc(Data');
    colorbar;
    colormap hot;
    hold all;

%     tresh=max(Data(:))/40;

    for j=1:size(Paths,1)
        Path=Paths{j};
        
        for i=1:dim(1)
                    plot(Path(i,1),Path(i,2),'.','color',[0,1,0])
        end
    end
end