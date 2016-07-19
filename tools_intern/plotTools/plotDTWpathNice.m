function surfMinimaPositions(Data,path)
% 
% switch nargin
%     case 1
%         slowAndNice=false(1);
%         labelx     =[];
%         labely     =[];
%         desc       =[];
%     case 2
%         slowAndNice=varargin{1};
%         labelx     =[];
%         labely     =[];
%         desc       =[];
%     case 3
%         slowAndNice=varargin{1};
%         labelx     =varargin{2};
%         labely     =[];
%         desc       =[];
%     case 4
%         slowAndNice=varargin{1};
%         labelx     =varargin{2};
%         labely     =varargin{3};
%         desc       =[];
%     case 5
%         slowAndNice=varargin{1};
%         labelx     =varargin{2};
%         labely     =varargin{3};
%         desc       =varargin{4};
%     otherwise
%         fprintf('surfMinimaPositions: Wrong number of arguments!\n');
% end

slowAndNice=true;

fhand=figure;
set(fhand,'Renderer','OpenGL');
dim=size(Data);

if(slowAndNice)

    z=max(max(Data))*2;
    x=dim(1)/2;
    y=dim(2)/2;
    
    surf(Data','edgecolor','none','FaceAlpha',0.9,'FaceLighting','phong','FaceColor','interp')
    material shiny;
    handle = light('Position',[x y z],'Style','infinite');
    
else
    surf(Data');
end

% set(gca,'XTick',1:3:size(Data,1));
% set(gca,'YTick',1:3:size(Data,2));
% 
% set(gca,'XTickLabel',labelx(1:3:size(labelx,2)));
% set(gca,'YTickLabel',labely(1:3:size(labely,2)));
% 
% title(desc);

axis square

colorbar;
%%% Andere Farben:
% colormap hot;
hold all;

% set(gca,'ZScale','log');

% % min=imregionalmin(Data);
% % 
% % % [r lists] = sort(Data,1);
% % 
% % tresh=max(Data(:))/40;
% % 
% % for i=1:dim(1)
% %     for j=1:dim(2)
% %         if((min(i,j)==1))%&&(Data(i,j)<tresh))
% %             plot3(j,i,Data(i,j),'*','color',[0,1,0]);
% %         end
% %     end
% % end

for point=1:size(path,1)
    plot3(path(point,1),path(point,2),Data(path(point,1),path(point,2)),'.','color',[0,1,0]);
end