function res=calcABS(mat)

dim=size(mat)
rows=size(mat{1}{1})
res1=zeros(size(mat{1}{1}));

for row=1:rows(1)
    for col=1:rows(2)
        for matr=1:dim(2)
            res1(row,col)=res1(row,col)+mat{matr}{1}(row,col)*mat{matr}{1}(row,col);
        end
        res1(row,col)=sqrt(res1(row,col));
    end
end
res=mat;
res{dim(2)+1}={res1,res{1}{2}};

for label=1:rows(2)
    res{dim(2)+1}{2}(label)=strrep(res{dim(2)+1}{2}(label),'_x','_ABS');
end
for label=1:rows(2)
    res{dim(2)+1}{2}(label)=strrep(res{dim(2)+1}{2}(label),'_X','_ABS');
end
    