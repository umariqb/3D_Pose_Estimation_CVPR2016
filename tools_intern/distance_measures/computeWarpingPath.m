function match = computeWarpingPath(C, noGraphics)

if nargin < 2
    noGraphics = false;
end

[N,M] = size(C);

D = zeros(N,M);

fprintf('Computing D (%5i rows): %5i',N,0);
D(1,1) = C(1,1);
for i=2:N
    D(i,1)=D(i-1,1)+C(i,1);
end
for j=2:M
    D(1,j)=D(1,j-1)+C(1,j);
end

for i=2:N
    if (mod(i,100)==0) fprintf('\b\b\b\b\b');fprintf('%5i',i); end;    
    for j=2:M
        D(i,j)=min([D(i-1,j), D(i,j-1), D(i-1,j-1)])+C(i,j);
    end
end
fprintf('\n');

match = zeros(N+M-1,2);
k=0;
while ((i>1) & (j>1))
    k=k+1;
    match(k,:)=[i j];
    if D(i,j)==D(i-1,j-1)+C(i,j)
        i=i-1;
        j=j-1;
    elseif D(i,j)==D(i,j-1)+C(i,j)
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

if ~noGraphics
    figure;
    imagesc(C);
    axis xy; axis equal;
    set(gca,'xlim',[1 M],'ylim',[1 N]);
    colormap(hot);
    colorbar;
    title('Cost matrix C(n,m)');
    %set(gcf,'Position',fig_pos);
    hold;
    h = plot(match(:,2),match(:,1),'.');
    set(h,'Color',[0.99 0.99 0.99]);
end