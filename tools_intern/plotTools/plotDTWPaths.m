function plotDTWPaths(Data,Paths,varargin)

%     figure;

% Data(isnan(Data)) = max(Data(~isnan(Data)))+1;
    colormap gray;
%     imagesc(Data')
    imagescnan([],[],Data',isnan(Data'),[0.3 0.3 1]);
    colorbar;
    hold all;

%     tresh=max(Data(:))/40;

    for j=1:size(Paths,1)
        Path=Paths{j};

        plot(Path(:,1),Path(:,2),'linewidth',2,'color',[1,0,0]);
        
%         for i=1:size(Path,1)
%                     plot(Path(i,1),Path(i,2),'*','color',[0,1,0])
%         end
    end
    
    switch nargin
        case 3
            title(varargin{1});
    end
    
    grid on;
end