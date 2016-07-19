if (0)
    clear all;
    tido;
    close all;
    
    % path_prefix = 'w:\shared\data_MoCap\';
    path_prefix = 's:\data_MoCap\MoCaDaDB\';
    
    files = {...
            [path_prefix 'HDM\Training\walk4StepsLstart\HDM_bd_walk4StepsLstart_001_120.amc'];...
            [path_prefix 'HDM\Training\walk4StepsLstart\HDM_bk_walk4StepsLstart_004_120.amc'];...
            [path_prefix 'HDM\Training\walk4StepsLstart\HDM_dg_walk4StepsLstart_007_120.amc'];...
            [path_prefix 'HDM\Training\walk4StepsLstart\HDM_mm_walk4StepsLstart_011_120.amc'];...
            [path_prefix 'HDM\Training\walk4StepsLstart\HDM_tr_walk4StepsLstart_014_120.amc'];...
            [path_prefix 'HDM\Training\walkBackwards4StepsRstart\HDM_bd_walkBackwards4StepsRstart_001_120.amc'];...
            [path_prefix 'HDM\Training\walkBackwards4StepsRstart\HDM_bk_walkBackwards4StepsRstart_004_120.amc'];...
            [path_prefix 'HDM\Training\walkBackwards4StepsRstart\HDM_dg_walkBackwards4StepsRstart_007_120.amc'];...
            [path_prefix 'HDM\Training\walkBackwards4StepsRstart\HDM_mm_walkBackwards4StepsRstart_011_120.amc'];...
            [path_prefix 'HDM\Training\walkBackwards4StepsRstart\HDM_tr_walkBackwards4StepsRstart_014_120.amc'];...
            [path_prefix 'HDM\Training\shuffle4StepsRStart\HDM_bd_shuffle4StepsRStart_001_120.amc'];...
            [path_prefix 'HDM\Training\shuffle4StepsRStart\HDM_bd_shuffle4StepsRStart_002_120.amc'];...
            [path_prefix 'HDM\Training\shuffle4StepsRStart\HDM_dg_shuffle4StepsRStart_004_120.amc'];...
            [path_prefix 'HDM\Training\shuffle4StepsRStart\HDM_mm_shuffle4StepsRStart_008_120.amc'];...
            [path_prefix 'HDM\Training\shuffle4StepsRStart\HDM_tr_shuffle4StepsRStart_011_120.amc'];...
            [path_prefix 'HDM\Training\jogLeftCircle4StepsRstart\HDM_bd_jogLeftCircle4StepsRstart_001_120.amc'];...
            [path_prefix 'HDM\Training\jogLeftCircle4StepsRstart\HDM_bk_jogLeftCircle4StepsRstart_003_120.amc'];...
            [path_prefix 'HDM\Training\jogLeftCircle4StepsRstart\HDM_dg_jogLeftCircle4StepsRstart_008_120.amc'];...
            [path_prefix 'HDM\Training\jogLeftCircle4StepsRstart\HDM_mm_jogLeftCircle4StepsRstart_011_120.amc'];...
            [path_prefix 'HDM\Training\jogLeftCircle4StepsRstart\HDM_tr_jogLeftCircle4StepsRstart_014_120.amc'];...
            [path_prefix 'HDM\Training\hopBothLegs1hops\HDM_bd_hopBothLegs1hops_001_120.amc'];...
            [path_prefix 'HDM\Training\hopBothLegs1hops\HDM_bk_hopBothLegs1hops_013_120.amc'];...
            [path_prefix 'HDM\Training\hopBothLegs1hops\HDM_dg_hopBothLegs1hops_022_120.amc'];...
            [path_prefix 'HDM\Training\hopBothLegs1hops\HDM_mm_hopBothLegs1hops_031_120.amc'];...
            [path_prefix 'HDM\Training\hopBothLegs1hops\HDM_tr_hopBothLegs1hops_034_120.amc'];...
            [path_prefix 'HDM\Training\jumpingJack3Reps\HDM_bd_jumpingJack3Reps_001_120.amc'];...
            [path_prefix 'HDM\Training\jumpingJack3Reps\HDM_bk_jumpingJack3Reps_004_120.amc'];...
            [path_prefix 'HDM\Training\jumpingJack3Reps\HDM_dg_jumpingJack3Reps_007_120.amc'];...
            [path_prefix 'HDM\Training\jumpingJack3Reps\HDM_mm_jumpingJack3Reps_010_120.amc'];...
            [path_prefix 'HDM\Training\jumpingJack3Reps\HDM_tr_jumpingJack3Reps_011_120.amc'];...
            [path_prefix 'HDM\Training\squat3Reps\HDM_bd_squat3Reps_001_120.amc'];...
            [path_prefix 'HDM\Training\squat3Reps\HDM_bk_squat3Reps_004_120.amc'];...
            [path_prefix 'HDM\Training\squat3Reps\HDM_dg_squat3Reps_007_120.amc'];...
            [path_prefix 'HDM\Training\squat3Reps\HDM_mm_squat3Reps_010_120.amc'];...
            [path_prefix 'HDM\Training\squat3Reps\HDM_tr_squat3Reps_011_120.amc'];...
            [path_prefix 'HDM\Training\kickRFront2Reps\HDM_bd_kickRFront2Reps_001_120.amc'];...
            [path_prefix 'HDM\Training\kickRFront2Reps\HDM_bk_kickRFront2Reps_004_120.amc'];...
            [path_prefix 'HDM\Training\kickRFront2Reps\HDM_dg_kickRFront2Reps_007_120.amc'];...
            [path_prefix 'HDM\Training\kickRFront2Reps\HDM_mm_kickRFront2Reps_010_120.amc'];...
            [path_prefix 'HDM\Training\kickRFront2Reps\HDM_tr_kickRFront2Reps_013_120.amc'];...
            [path_prefix 'HDM\Training\kickRSide2Reps\HDM_bd_kickRSide2Reps_001_120.amc'];...
            [path_prefix 'HDM\Training\kickRSide2Reps\HDM_bk_kickRSide2Reps_004_120.amc'];...
            [path_prefix 'HDM\Training\kickRSide2Reps\HDM_dg_kickRSide2Reps_007_120.amc'];...
            [path_prefix 'HDM\Training\kickRSide2Reps\HDM_mm_kickRSide2Reps_010_120.amc'];...
            [path_prefix 'HDM\Training\kickRSide2Reps\HDM_tr_kickRSide2Reps_013_120.amc'];...
            [path_prefix 'HDM\Training\cartwheelLHandStart1Reps\HDM_bd_cartwheelLHandStart1Reps_001_120.amc'];...
            [path_prefix 'HDM\Training\cartwheelLHandStart1Reps\HDM_bk_cartwheelLHandStart1Reps_005_120.amc'];...
            [path_prefix 'HDM\Training\cartwheelRHandStart1Reps\HDM_dg_cartwheelRHandStart1Reps_001_120.amc'];...
            [path_prefix 'HDM\Training\cartwheelLHandStart1Reps\HDM_mm_cartwheelLHandStart1Reps_008_120.amc'];...
            [path_prefix 'HDM\Training\cartwheelLHandStart1Reps\HDM_tr_cartwheelLHandStart1Reps_011_120.amc'];...
};
    
    mot = emptyMotion;
    for k=1:length(files)
        [skel,mot(k)] = readMocap(files{k});    
        mot(k) = integerDownsampleMot(mot(k),4);
    end
    [mot,starts] = concatMot(mot,skel);
    starts5 = starts(1:5:length(starts));
    
    %[skel,mot] = readMocapD(89); %147
    
end

trajIDs = [1:9]; %lower extremities
%trajIDs = [1 12 16:19 21:24]; % root, neck, arms
%trajIDs = [1:9 16:19 21:24]; % upper and lower extremities

% now generate all 3-combinations of trajectory IDs, defining planes
planePoints = nchoosek(trajIDs,3);

% % remove those combinations of plane points yielding a small average triangle area for this motion (eliminate unstable planes!)
% areaMeanThresh = 3*(skel.nodes(DOFID(skel,'lshoulder')).length).^2 / 2; % threshold for mean triangle area: 2 * area of right triangle formed by 2 lhumeri
% area = zeros(size(planePoints,1),mot.nframes);
% for k = 1:size(planePoints,1)
%     area(k,:) = feature_areaTriangle(mot,planePoints(k,1),...
%                                          planePoints(k,2),...
%                                          planePoints(k,3));
% end
% %areaVarThresh = 0.250 * max(var(area')); % threshold for triangle area variance: 25% of max variance
% range = max(area')'-min(area')';
% rangeThresh = 0.5 * max(range);
% goodPlanePoints = find(range' <= rangeThresh); % row indices of admissible plane point combinations
% %goodPlanePoints = find((mean(area') >= areaMeanThresh) & (range' <= rangeThresh)); % row indices of admissible plane point combinations
% %goodPlanePoints = find((mean(area') >= areaMeanThresh) & (var(area') <= areaVarThresh)); % row indices of admissible plane point combinations
% %goodPlanePoints = find(mean(area') >= areaMeanThresh); % row indices of admissible plane point combinations
% planePoints = planePoints(goodPlanePoints,:);

% now combine the surviving 3-combinations with each of the trajectory IDs not appearing in the respective 3-combination
combi = zeros(size(planePoints,1)*(length(trajIDs)-3),4);
for k = 1:size(planePoints,1)
    combi((k-1)*(length(trajIDs)-3)+1:k*(length(trajIDs)-3),1:3) = repmat(planePoints(k,:),length(trajIDs)-3,1);
    combi((k-1)*(length(trajIDs)-3)+1:k*(length(trajIDs)-3),4) = setdiff(trajIDs,planePoints(k,:))'; % setdiff gets rid of the trajIDs already used in planePoints(k) 
end

f = size(combi,1);

M = zeros(2*size(combi,1),mot.nframes);
for k=1:size(combi,1)
    feature = feature_distPointPlane(mot,combi(k,1),...
                                         combi(k,2),...
                                         combi(k,3),...
                                         combi(k,4));         
    feature = feature/(max(feature)-min(feature));  % normalization by data range
%    M(k,:) = (feature-mean(feature)) >= 0;  
    M(k,:) = feature;  
end
for k=1:size(combi,1)
    feature = feature_distPointNormalPlane(mot,combi(k,1),...
                                         combi(k,2),...
                                         combi(k,3),...
                                         combi(k,4));         
    feature = feature-mean(feature);
    feature = feature/(max(feature)-min(feature)); 
%    M(size(combi,1)+k,:) = (feature-mean(feature)) >= 0;  
    M(size(combi,1)+k,:) = feature;  
end
% % C = corrcoef(M');
% C = cov(M');
% vars = diag(C); maxVar = max(vars);
% covsums = (sum(abs(C))' - vars)/size(C,1); maxCovSum = max(covsums);
% varWeight = 1;
% %quality = varWeight*vars/maxVar - covsums/maxCovSum;
% quality = vars;
% %quality = -covsums;

% [quality_sort,indices] = sort(-quality(:,e));
% quality_sort = -quality_sort;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% M_bool = M >= 0;
% %rowsums = sum(M_bool');
% %[rowsums, indices] = sort(rowsums);
% %M_bool = M_bool(indices,:);
% [Y_bool,PC_bool,V_bool] = pca(M_bool);
% [quality_sort,indices] = sort(-PC_bool(:,e));
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Y,PC,V] = pca(M);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
e = 3;
[quality_sort,indices] = sort(-abs(PC(:,e)));
quality_sort = PC(indices,e);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [quality_sort,indices] = sort(-quality);
% quality_sort = -quality_sort;

for r = 1:min(20,length(indices))
    if (indices(r)>size(combi,1))
        str = 'N';
        I = indices(r)-size(combi,1);
    else
        str = 'P';
        I = indices(r);
    end

    p1 = combi(I,1);
    p1_name = skel.nameMap{p1,1};
    p2 = combi(I,2);
    p2_name = skel.nameMap{p2,1};
    p3 = combi(I,3);
    p3_name = skel.nameMap{p3,1};
    q = combi(I,4);
    q_name = skel.nameMap{q,1};
    
    s = sprintf('%s %4d %12.6g %10s(%2d) %10s(%2d) %10s(%2d) %10s(%2d)',str, r, quality_sort(r),p1_name, p1, p2_name, p2, p3_name, p3, q_name, q);
%    s = sprintf('%4d %12.6g %10s %10s %10s %10s',r, PC(r,e),p1, p2, p3, q);
    disp(s)
end
% for e = 1:min(100,length(indices))
%     p1 = skel.nameMap{combi(indices(e),1),1};
%     p2 = skel.nameMap{combi(indices(e),2),1};
%     p3 = skel.nameMap{combi(indices(e),3),1};
%     q = skel.nameMap{combi(indices(e),4),1};
% 
%     s = sprintf('%4d %12.6g %10s %10s %10s %10s',e,PC(r,e),p1, p2, p3, q);
%     disp(s)
% end



% figure
% imagesc(Y(1:20,:));
% colormap([flipud(bone); copper]); colorbar;

colors =...
       [255 0   0;...      % red
        200   255 80;...    % green
        0   0   255;...    % blue
        0   255 255;...    % cyan
        0   128 0;...      % dirty green
        255 0   128;...    % pink
        128 0   0;...      % wine red
        128 0   255;...    % purple
        255 128 0;...      % orange
        164 164 164;...    % grey
        0   255 0;...      % light green
        192 192 192;...    % light grey
        64  128 128;...    % greenish blue
        255 128 255;...    % light pink
        128 128 0;...      % olive green
        255 255 0;...      % yellow
        198 255 198]/255;  % mint green

p = 3;
figure
segs = [starts5 mot.nframes];
for k=1:p
    subplot(p,1,k); hold on;
    for j=2:11
        plot(segs(j-1):segs(j),Y(k,segs(j-1):segs(j)),'color',colors(j-1,:));
    end
    set(gca,'xlim',[1 mot.nframes],'ylim',[-12 12],'box','off');
%    if (k==1)
%        set(gca,'xaxislocation','top');
%    end
%    if (k<p)
        set(gca,'xticklabel',[]);
        set(gca,'yticklabel',[]);
%    end
end

% printPaperPosition = [1   10   12.6  4.4]; %[left, bottom, width, height]
% set(gcf,'PaperPosition',printPaperPosition); 
% printName = 'figures\print\figure_PCA_PC1to3.eps';
% print('-depsc2',printName);

p = 3;
figure
for k=1:p
    subplot(p,1,k); 
%    plot(abs(PC(:,k)),'k'); hold;
    plot(PC(:,k),'k'); hold;
    [y,I] = max(abs(PC(:,k)));
%     plot(I,y,'red o');
    plot(I,PC(I,k),'red o');
    set(gca,'xlim',[1 2*f],'ylim',[-0.11 0.11],'box','off');
    set(gca,'xticklabel',[]);
    set(gca,'yticklabel',[]);
end
pos = get(gca,'position');
pos(4) = 3.65*pos(4);
hax = axes('position',pos,'visible','off');
line([505 505],[0 0.4],'linestyle','- -','parent',hax);

printPaperPosition = [1   10   12.6  4.4]; %[left, bottom, width, height]
set(gcf,'PaperPosition',printPaperPosition); 
printName = 'figures\print\figure_PCA_factorLoadings1to3.eps';
print('-depsc2',printName);


figure
p=3;
segs = [starts5 mot.nframes];
for e=1:p
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [quality_sort,indices] = sort(-abs(PC(:,e)));
    quality_sort = PC(indices,e);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    r = 1;    

    if (indices(r)>size(combi,1))
        I = indices(r)-size(combi,1);
    else
        I = indices(r);
    end

   p1 = combi(I,1);
   p2 = combi(I,2);
   p3 = combi(I,3);
   q = combi(I,4);

   if (indices(r)>size(combi,1))
       feature = feature_distPointNormalPlane(mot,p1,p2,p3,q);
   else
       feature = feature_distPointPlane(mot,p1,p2,p3,q);
   end

%    feature = M(I,:);
    
    
    subplot(p,1,e); hold on;
    for j=2:11
        plot(segs(j-1):segs(j),feature(segs(j-1):segs(j)),'color',colors(j-1,:));
    end
    set(gca,'xlim',[1 mot.nframes],'ylim',[-12 12],'box','off');
    set(gca,'xticklabel',[]);
    set(gca,'yticklabel',[]);
end

% printPaperPosition = [1   10   12.6  4.4]; %[left, bottom, width, height]
% set(gcf,'PaperPosition',printPaperPosition); 
% printName = 'figures\print\figure_PCA_features_1to3.eps';
% print('-depsc2',printName);


figure
hold on;

colors =...
       [255 0   0;...      % red
        200   255 80;...    % green
        0   0   255;...    % blue
        0   255 255;...    % cyan
        0   128 0;...      % dirty green
        255 0   128;...    % pink
        128 0   0;...      % wine red
        128 0   255;...    % purple
        255 128 0;...      % orange
        164 164 164;...    % grey
        0   255 0;...      % light green
        192 192 192;...    % light grey
        64  128 128;...    % greenish blue
        255 128 255;...    % light pink
        128 128 0;...      % olive green
        255 255 0;...      % yellow
        198 255 198]/255;  % mint green

segs = [starts5 mot.nframes];
d = [1 2 3];
a = 1;
b = length(segs)-1;
s = starts5(a);
for k=a:b
    plot3(Y(d(1),s:segs(k+1)),Y(d(2),s:segs(k+1)),Y(d(3),s:segs(k+1)),'color',colors(k,:),'marker','.');
    s = segs(k+1);
end
%set(gcf,'renderer','opengl');