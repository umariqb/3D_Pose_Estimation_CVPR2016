function plotBlendingPositions(Data,num)

figure;
dim=size(Data);
%  A=tril(ones(dim(1),dim(1))*max(Data(:)),-50);
%  B=tril(ones(dim(1),dim(1))*max(Data(:)), 50);
%  Data=Data+B-A;

imagesc(Data');
colorbar;
colormap hot;
hold all;

[r lists] = sort(Data,1);

for i=1:dim(1)
    for j=1:num
        plot(i,lists(j,i),'.','color',[0,1,0])
    end
end