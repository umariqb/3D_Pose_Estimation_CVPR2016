function res=unstackVec3dData(mat)

components=size(mat{1}{1})

row=0;
for r=1:3:components(2)
    row=row+1;
    tmp1(:,row)=mat{1}{1}(:,r);
    tmp2(1,row)=mat{1}{1,2}(r);
end
res{1}={tmp1,tmp2};
row=0;
for r=2:3:components(2)
    row=row+1;
    tmp1(:,row)=mat{1}{1}(:,r);
    tmp2(1,row)=mat{1}{1,2}(r);
end
res{2}={tmp1,tmp2};
row=0;
for r=3:3:components(2)
    row=row+1;
    tmp1(:,row)=mat{1}{1}(:,r);
    tmp2(1,row)=mat{1}{1,2}(r);
end
res{3}={tmp1,tmp2};