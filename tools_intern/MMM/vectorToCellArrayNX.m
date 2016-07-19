function X=vectorToCellArrayNX(x,sizes)
j=1;
for i=1:size(sizes,2)
    for k=1:size(x,1)
        X{k,i}      = x(k,j:j+sizes(i)-1);
    end
    j = j+sizes(i);
end