%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Motion Retrieval via substring DTW based on motion templates
% by Meinard Mueller, 10.11.2005
%
% V       n times p matrix, data stream of length n with p dimensional feature vectors
% W       m times p matrix, data stream of length n with p dimensional feature vectors 
% hits    struct array, see below
% costF   1 x p array containing the costs per feature
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hits,C,D,Delta, classificationDelta]=motionTemplateDTWRetrievalWeightedForClassification(V,Vweights,W,Wweights,parameter,varargin)

di = [1 0 1];
dj = [1 1 0];
if (nargin>6)
    dj = varargin{2};
end
if (nargin>5)
    di = varargin{1};
end
if (nargin>7)
    dWeights = varargin{3};
else
    dWeights = ones(1,length(di));
end

if (parameter.expandV==1)
    [V,Vweights] = expandWeightedVectorSequence(V,Vweights);
end

V = V';
W = W';

n = size(V,1);
p = size(V,2);
m = size(W,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Global cost matrix for matching i-th feature with j-th feature
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
V_0 = double(V==0)+double(V==0.5);
V_1 = double(V==1)+double(V==0.5);

C = V_1*W' + V_0*(1-W');             % #(concurrences)
C = p-C;                             % #(disagreements)
C = C/n;                             % disagreements per frame in V
%C = C/(p*n);                        % disagreements per feature and frame in V
%C = C_DTW_compute_C(V,W); % slower
num_V_nonfuzzy = max(1,sum(V~=0.5,2));
C = C.*((repmat(Vweights',1,m)+repmat(Wweights,n,1))./(2*repmat(num_V_nonfuzzy,1,m)));
%C = C.*((repmat(Vweights',1,m)+repmat(Wweights,n,1))/2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computing optimal match by dynamic programming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tic;
% D = zeros(n,m);
% E = zeros(n,m);
% 
% D(1,1) = C(1,1);
% for i=2:n
%     D(i,1)=D(i-1,1)+C(i,1);
% end
% for j=2:m
%     D(1,j)=C(1,j);
% end
% 
% for i=2:n
%     for j=2:m
%         indices = sub2ind(size(D),max(i-di,1),max(j-dj,1));
%         [val,E(i,j)] = min(D(indices));
%         
%         D(i,j) = val + dWeights(E(i,j))*C(i,j);
%     end
% end

%%%%%%%% equivalent C code, improves efficiency by roughly a factor of 150
[D,E] = C_DTWpartial_compute_D_variablePathSteps(C,int32(di),int32(dj),dWeights);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%t=toc; fprintf('%f',t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Matches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Delta = D(n,:);
match_numMax = parameter.match_numMax;
match_thresh = parameter.match_thresh;

hits = struct('file_id',0,...                   % file ID, index into idx.files
              'file_name','',...
              'cost',0,...
              'match',0,...                     % num x 2 array encoding the matched indices
              'frame_first_matched_all',0,...   % the first frame of this hit (using a continuous frame count for the entire database)
              'frame_last_matched_all',0,...    % the last frame of this hit  (using a continuous frame count for the entire database)
              'frame_first_matched',0,...       % the first frame of this hit
              'frame_last_matched',0,...        % the last frame of this hit     
              'frame_length',0);                % the length of this hit measured in frames
hits = repmat(hits,match_numMax,1);

Delta_help = Delta;
classificationDelta = inf*ones(1, length(Delta));
counter = 0;
[cost,pos] = min(Delta_help);
while counter<match_numMax && cost <= match_thresh
    i=n;
    j=pos;
    match_temp = zeros(max(n,m),2);
    k=0;
    while ((i>1) && (j>1))
        k=k+1;
        match_temp(k,:)=[i j];
        i2 = i - di(E(i,j));
        j2 = j - dj(E(i,j));
        i = i2;
        j = j2;
    end
    k = k+1;
    match_temp(k,:)=[i j];
    while (i>1)
        i = i-1;
        k=k+1;
        match_temp(k,:)=[i j];
    end
    match_temp = match_temp([1:k],:);
    match_temp = flipud(match_temp)';
    

        %set all positions in the range of this hit to the value cost if
        %the value has not been set previously.
        positionsNotSet = (classificationDelta==inf);
        positionsMatch = false(1, length(positionsNotSet));
        positionsMatch(match_temp(2,1):match_temp(2,end)) = true;
        % do a posewiese AND function of both masks to get the positions
        % where the new cost value may be set.
        classificationDelta(positionsNotSet & positionsMatch) = cost;

        counter = counter+1;
        %hits(counter).match = match_temp;
        hits(counter).frame_first_matched_all =  match_temp(2,1);
        hits(counter).frame_last_matched_all = match_temp(2,end);
        hits(counter).cost = cost;
        current_match_length = match_temp(2,end)-match_temp(2,1)+1;
            
%         ind_start = match_temp(2,1);
%         ind_end = match_temp(2,end);
        %matches_length(ind_start:ind_end) = repmat(current_match_length,1,ind_end-ind_start+1);
        %matches_length(ind_start:ind_end) = counter; 
    
    %pufferBackward = ceil(parameter.match_endExclusionBackward*current_match_length);
    %pufferForward = ceil(parameter.match_endExclusionForward*current_match_length);
    %ind_start = max(match_temp(2,end)-pufferBackward,1);
    %ind_end   = min(match_temp(2,end)+pufferForward,m);
    
    pufferBackward = ceil(parameter.match_startExclusionBackward*current_match_length);
    pufferForward = ceil(parameter.match_endExclusionForward*current_match_length);
    ind_start = max(match_temp(2,1)-pufferBackward,1);
    ind_end   = min(match_temp(2,end)+pufferForward,m);
    
    Delta_help(ind_start:ind_end)=Inf;
    [cost,pos] = min(Delta_help);
end
hits = hits(1:counter);

if counter == match_numMax
    error('The maximum number of hits did not suffice.');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Visualizations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if parameter.visCost == 1   
    figure;
    set(gcf,'Position',[30 551 1210 398]);
    subplot(2,1,1)
    C_vis = C;
    C_vis(isnan(C_vis))=max(max(C_vis));
    imagesc(C_vis);
    axis xy;
    colormap(hot);
    colorbar;
    D_vis = D;
    D_vis(isnan(D_vis))=max(max(D_vis));
    subplot(2,1,2)
    imagesc(D_vis);
    axis xy;
    colormap(hot);
    colorbar;
    hold on;
    for k=1:length(hits)
    plot(hits(k).match(2,:),hits(k).match(1,:),'.c');
    end

%    h=figure;
%    plot(Delta);
%    set(h,'position',[0 161 1275 229]);

end


