close all

% clear all;
load D
files = D2filenames(D);

features_spec = features_spec_struct(11);
features_spec(1).name = 'feature_bool_footRightBack';
features_spec(2).name = 'feature_bool_footLeftBack';
features_spec(3).name = 'feature_bool_footRightLift'; 
features_spec(4).name = 'feature_bool_footLeftLift'; 
features_spec(5).name = 'feature_bool_footRightSideways'; 
features_spec(6).name = 'feature_bool_footLeftSideways'; 
features_spec(7).name = 'feature_bool_kneeRightAngle'; 
features_spec(8).name = 'feature_bool_kneeLeftAngle'; 
features_spec(9).name = 'feature_bool_footCrossover'; 
features_spec(10).name = 'feature_bool_footRightHighVel'; features_spec(10).win_length_ms = 100;
features_spec(11).name = 'feature_bool_footLeftHighVel'; features_spec(11).win_length_ms = 100;

features_spec_robust = features_spec_struct(11);
features_spec_robust(1).name = 'feature_bool_footRightBack_robust';
features_spec_robust(2).name = 'feature_bool_footLeftBack_robust';
features_spec_robust(3).name = 'feature_bool_footRightLift_robust'; 
features_spec_robust(4).name = 'feature_bool_footLeftLift_robust'; 
features_spec_robust(5).name = 'feature_bool_footRightSideways_robust'; 
features_spec_robust(6).name = 'feature_bool_footLeftSideways_robust'; 
features_spec_robust(7).name = 'feature_bool_kneeRightAngle_robust'; 
features_spec_robust(8).name = 'feature_bool_kneeLeftAngle_robust'; 
features_spec_robust(9).name = 'feature_bool_footCrossover_robust';
features_spec_robust(10).name = 'feature_bool_footRightHighVel_robust'; features_spec_robust(10).win_length_ms = 100;
features_spec_robust(11).name = 'feature_bool_footLeftHighVel_robust'; features_spec_robust(11).win_length_ms = 100;

%F = features_extract(files,features_spec);
%save F F
load F

%F_robust = features_extract(files,features_spec_robust);
%save F_robust F_robust
load F_robust

index = index_build(F,[1:11]);
index_robust = index_build(F_robust,[1:11]);

frame_lengths=[];
features = [];
for k=1:index.files_num
    frame_lengths = [frame_lengths index.segments(k).frames_length];
    features = [features index.segments(k).features];
end

frame_lengths_robust=[];
features_robust = [];
for k=1:index_robust.files_num
    frame_lengths_robust = [frame_lengths_robust index_robust.segments(k).frames_length];
    features_robust = [features_robust index_robust.segments(k).features];
end

sum(frame_lengths)

mean(frame_lengths)
mean(frame_lengths_robust)

std(frame_lengths)
std(frame_lengths_robust)

median(frame_lengths)
median(frame_lengths_robust)

min(frame_lengths)
min(frame_lengths_robust)

max(frame_lengths)
max(frame_lengths_robust)

m = 120;
figure;
h = hist(frame_lengths(frame_lengths<=m),m);
b = bar(h.*[1:m]); set(b,'facecolor',[100 100 255]/255,'edgecolor','k','edgealpha',1,'facealpha',1);
set(gca,'xlim',[0 m+0.5],'ylim',[0 9000]);

%figure;
hold on;
hr = hist(frame_lengths_robust(frame_lengths_robust<=m),m);
b = bar(hr.*[1:m],'r'); set(b,'facecolor','m','edgecolor','k','edgealpha',1,'facealpha',0.6);
%hist(frame_lengths_robust(frame_lengths_robust<=200),201)
set(gca,'yticklabel',[],'xticklabel',[]);

set(gca,'box','off')
printPaperPosition = [1   10   30  8]; %[left, bottom, width, height]
set(gcf,'PaperPosition',printPaperPosition); 
printName = 'print/figure_robust_hist.eps';
print('-depsc2',printName);
