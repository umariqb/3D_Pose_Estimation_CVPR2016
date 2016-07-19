function [C,q1,q2] = costMatrixQuat(mot1,mot2,parameter);


filt_n   = parameter.filter_len;
ds       = parameter.downsample;
joints   = parameter.joints;
weigths  = parameter.jointsWeight;
vis      = parameter.visualize;
fig_pos  = parameter.figure_position; 

num_joints = length(joints);
moving_avg = orientationFilter(1/filt_n*ones(1,filt_n));


% Filter and downsample
len1  = size(mot1.rotationQuat{1},2);
ds_ind1   = (1:ds:len1);
q1 = cell(num_joints,1);
for r=1:num_joints
	q = mot1.rotationQuat{mot1.nameMap{joints(r),2}};
    if (filt_n>1) && (size(q,2) > size(moving_avg,2))
        q = filterS3(moving_avg,q,'zero');
    end
    q1{r} = q(:,ds_ind1);
end
q2 = cell(num_joints,1);
len2  = size(mot2.rotationQuat{1},2);
ds_ind2   = (1:ds:len2);
for r=1:num_joints
	q = mot2.rotationQuat{mot2.nameMap{joints(r),2}};
    if (filt_n>1) && (size(q,2) > size(moving_avg,2))
        q = filterS3(moving_avg,q,'zero');
    end
    q2{r} = q(:,ds_ind2);
end

%Compute cost matrix 
N = length(ds_ind1);
M = length(ds_ind2);
C = zeros(N,M);
fprintf('Computing C (%i joints): %3i',num_joints,0)
for r=1:num_joints
    fprintf('\b\b\b');fprintf('%3i',r);
    C = C + weigths(r).*(1-abs((q1{r}'*q2{r})));
%    C = C + weigths(r).*(1-(q1{r}'*q2{r}));
end
fprintf('\n');

if vis(1) == 1
    figure;
    imagesc(C);
    axis xy;
    axis equal;
    set(gca,'xlim',[1 N],'ylim',[1 M]);
    colormap(jet);
    colorbar;
    %title('Local cost matrix C(n,m)');
    set(gcf,'Position',fig_pos);
end
if vis(2) == 1
    figure;
    surf(C);
    colormap(jet);
    %colorbar;
    shading interp;
    lighting phong;
    axis tight;
    view(-31.5,82);
end

if vis(3) == 1
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
        
    figure;
    imagesc(C);
    axis xy; axis equal;
    set(gca,'xlim',[1 M],'ylim',[1 N]);
    colormap(jet);
    colorbar;
    %title('Local cost matrix C(n,m)');
    set(gcf,'Position',fig_pos);
    hold;
    h = plot(match(:,2),match(:,1),'.');
    set(h,'Color',[0.99 0.99 0.99]);
end



