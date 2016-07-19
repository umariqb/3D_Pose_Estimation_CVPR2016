function D=TensorDifferenz(T1,T2)

dim1=size(T1);
dim2=size(T2);
if(sum(dim1-dim2)==0)
    T1s=T1(:);
    T2s=T1(:);
    D=0;
    for i=1:size(T1s,1)
        if(~isnan(T1s(i))&&~isnan(T2s(i)))
            D=D+abs(T1s(i)-T2s(i));
        end
    end    
else
    error('TensorDifferenz: Tensors must be of same size!\n');
end