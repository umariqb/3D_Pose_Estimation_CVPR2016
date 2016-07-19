function match = test_DTW(C)
%%%%%%%% equivalent C code, improves efficiency
[D,E] = C_DTW_compute_D(C);
[n,m] = size(C);
i = n;
j = m;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

match = zeros(n+m-1,2);
k=0;
while ((i>1) & (j>1))
    k=k+1;
    match(k,:)=[i j];
    if E(i,j)==1
        j=j-1;    
        i=i-1;
    elseif E(i,j)==2
        j=j-1;
    else      
        i=i-1;
    end
end
k = k+1;
match(k,:)=[i j];
while (i>1)
    i = i-1;
    k=k+1;
    match(k,:)=[i j];
end
while (j>1)
    j = j-1;
    k=k+1;
    match(k,:)=[i j];
end

match = match([1:k],:);
match = flipud(match);
cost = D(n,m);
match = match';
match_v = match(1,:);
match_w = match(2,:);

%plot(match(2,:),match(1,:),'.c');