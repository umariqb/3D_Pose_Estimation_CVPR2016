function plotDTWPath(Data,path)

% figure;
%dim=size(Data);

surf(Data');
colorbar;

%colormap hot;
hold all;


for point=1:size(path,1)
    plot3(path(point,1),path(point,2),Data(path(point,1),path(point,2)),'.','color',[0,1,0]);
end