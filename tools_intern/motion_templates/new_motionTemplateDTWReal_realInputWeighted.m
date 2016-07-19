%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cost of features
% by Meinard Mueller, 03.06.2005
%
% V       n times p matrix, data stream of length n with p dimensional feature vectors
% W       m times p matrix, data stream of length n with p dimensional feature vectors 
% match   num x 2 array encoding the matched indices
% costF   1 x p array containing the costs per feature
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Wwarp,WwarpWeights,VrepW,match,cost,C,D]=motionTemplateDTW_realInputWeighted(V,Vweights,W,Wweights,parameter)

V = V';
W = W';

n = size(V,1);
p = size(V,2);
m = size(W,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Global cost matrix for matching i-th feature with j-th feature
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C = zeros(n,m);
% for i=1:n
%     for j=1:m
%         C(i,j) = norm(V(i,:)-W(j,:),1) / p;
%     end
% end
% computes pairwise L_1 distance between feature vectors
%%%%%%%% equivalent C code, improves efficiency by roughly a factor of 10
C = C_DTW_compute_Creal(V,W); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C = C.*((repmat(Vweights',1,m)+repmat(Wweights,n,1))/2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computing optimal match by dynamic programming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %Attention: MATLAB indexing always begins with index 1
% D = zeros(n,m);
% E = zeros(n,m);
% 
% D(1,1) = C(1,1);
% for i=2:n
%     D(i,1)=D(i-1,1)+C(i,1);
% end
% for j=2:m
%     D(1,j)=D(1,j-1)+C(1,j);
% end
% 
% for i=2:n
%     for j=2:m
%             [val,E(i,j)] = min([D(i-1,j-1), D(i,j-1), D(i-1,j)]); %diag, horz, vert
%             D(i,j) = val+C(i,j); 
%        end
% end

%%%%%%%% equivalent C code, improves efficiency
[D,E] = C_DTW_compute_D(C);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% De-warp VwarpTemplate into Vtemplate, yielding a sequence 
% of the same length as V, while averaging columns that are
% replicated in the match of V to W using Wweights. 
% Normalize each resulting column by the sum of Wweights used 
% in the averaging process.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
WwarpMatch = W(match_w,:)';
WwarpMatchWeights = Wweights(match_w);

match_len = length(match_v);
Wwarp = zeros(p,n);
WwarpWeights = zeros(1,n);

[Vruns, Vruns_start, Vrep] = runs_find_constant(match_v);
for k=1:length(Vruns)
    b = Vruns(k);
    range = Vruns_start(k):Vruns_start(k)+Vrep(k)-1;
    X = repmat(WwarpMatchWeights(range),p,1);
    Wwarp(:,b) = Wwarp(:,Vruns(k))+sum(X.*WwarpMatch(:,range),2);
    WwarpWeights(b) = WwarpWeights(b)+sum(WwarpMatchWeights(range));    
end
Wwarp = Wwarp./repmat(WwarpWeights,p,1);
% for k=1:match_len
%     b = match_v(k);
%     Wwarp(:,b) = Wwarp(:,b)+WwarpMatch(:,k)/Vrep(b);
%     WwarpWeights(b) = WwarpWeights(b)+WwarpMatchWeights(k);    
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute a 2 x m matrix VrepW, column j of which 
% encodes a pair (start_j,end_j). These entries are indices 
% into V, and denote segments within V that match to the same
% frame j in W.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Wruns, Wruns_start, Wrep] = runs_find_constant(match_w);
VrepW = [match_v(Wruns_start); match_v(Wruns_start+Wrep-1)];

for k=1:m % normalize each Wweight(j) by the number of elements in V matching to W(j)
    WwarpWeights(VrepW(1,k):VrepW(2,k)) = WwarpWeights(VrepW(1,k):VrepW(2,k))/Wrep(k);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Visualizations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if parameter.visCost == 1   
    figure;
    imagesc(C,[0 p]);
    axis xy;
    colormap(hot);
    colorbar;
    title(['Local cost matrix C, D(n,m)=',num2str(D(n,m)),', #(match)=',num2str(size(match,2))]);
    hold on;
    plot(match(2,:),match(1,:),'.c');
end

if parameter.visWarp == 1   
    figure;
    subplot(2,1,1);
    plot(WwarpWeights); title('WwarpWeights');
    colorbar;
    subplot(2,1,2); 
    imagesc(Wwarp,[0 1]); title('Wwarp');
    colormap(hot); colorbar;
    drawnow;
%    subplot(2,2,3); 
%    imagesc(VwarpEqual,[0 1]); title('VwarpEqual');
 %   subplot(2,2,4);
%    imagesc(Vequal,[0 1]); title('Vequal');
end    


