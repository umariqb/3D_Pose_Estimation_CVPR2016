function X=vectorToCellArray(x,sizes)
j=1;
for i=1:length(sizes)
    X{i}        = x(j:j+sizes(i)-1);
    j           = j+sizes(i);
end