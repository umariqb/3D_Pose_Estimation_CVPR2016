%gather_data = false;
gather_data = true;

downsampling_fac = 4;

if (gather_data)
    basedir_templates = 'S:\data_MoCap\MoCaDaDB\HDM\Training\_templates\templates_AK_upper_AK_lower_AK_mix_5_0_30';
    basedir_features = 'S:\data_MoCap\MoCaDaDB\HDM\Training\_features\AK_lower';
    
    d = dir([basedir_templates filesep '*.mat']);
    
    N = length(d);
    template_stats = [];
    template_params = [];
    for k=1:N
        load([basedir_templates filesep d(k).name]);
        if (k==1)
            template_stats = statistics;
            template_params = parameter;
        else
            template_params = [template_params; parameter];
            template_stats = [template_stats; statistics];
        end
    end

    d = dir([basedir_features filesep '*.mat']);
    
    N = length(d);
    MC_files_frame_length = cell(N,1);
    counter = 0;
    for k=1:N
        load([basedir_features filesep d(k).name]);
        num_files = length(F.features);
        if (num_files>1)
            files_frame_length = zeros(1,num_files);
            for j=1:num_files
                files_frame_length(j) = sum(F.features{j}{1});
            end
            counter = counter+1;
            MC_files_frame_length{counter} = floor(files_frame_length/downsampling_fac);
        end
    end
    MC_files_frame_length = MC_files_frame_length(1:counter);

    load motionTemplateBatchInfo_50
    I = zeros(length({motionTemplateBatchInfo.used}),1);
    counter = 0;
    for k=1:length(motionTemplateBatchInfo)
        if (motionTemplateBatchInfo(k).used(1)>0)
            counter = counter+1;
            I(counter) = k;
        end
    end
    I = I(1:counter);
    motionTemplateBatchInfo = motionTemplateBatchInfo(I);
end

MC_categories = {template_params.category}';

% categories = {'cartwheelLHandStart1Reps',...
%               'elbowToKnee1RepsRelbowStart',...
%               'jumpingJack1Reps',...
%               'kickRFront1Reps',...
%               'kickRSide1Reps',...
%               'lieDownFloor',...
%               'rotateArmsRBackward3Reps',...
%               'rotateArmsRForward3Reps',...
%               'walkRightCrossFront3Steps',...
%               'walkLeft3Steps',...
% };

load bd_motion_classes
categories = motion_classes;

indices=zeros(1,length(categories));
for j=1:length(categories)
    category = categories{j};
    k = strmatch(category,MC_categories,'exact');
    if (~isempty(k))
        indices(j)=k(1);
    end
end
num_categories = length(categories);
template_stats_restricted = template_stats(indices);
MC_files_frame_length_restricted = MC_files_frame_length(indices);
motionTemplateBatchInfo_restricted = motionTemplateBatchInfo(indices);

iter_num = [template_stats_restricted.iter_num]';
fprintf('\nMin number of iterations over all classes: %d\n',min(iter_num));
fprintf('Max number of iterations over all classes: %d\n',max(iter_num));

s = zeros(num_categories,1);
for k=1:num_categories
    s(k) = sum(template_stats_restricted(k).iter_running_time);
end
fprintf('\nAverage computation time over all classes: %f s\n',mean(s));
fprintf('Std of  computation time over all classes: %f s\n',std(s));

l = zeros(num_categories,1);
f = zeros(num_categories,1);
n = zeros(num_categories,1);
for k=1:num_categories
    l(k) = mean(MC_files_frame_length_restricted{k}(motionTemplateBatchInfo_restricted(k).used));
    f(k) = sum(MC_files_frame_length_restricted{k});
    n(k) = length(MC_files_frame_length_restricted{k});
end
fprintf('\nMin avg number of frames over all classes: %f\n',min(l));
fprintf('Max avg number of frames over all classes: %f\n',max(l));

fprintf('\nTotal number of frames over all classes: %d, %f minutes\n',sum(f),sum(f)/30/60);
fprintf('Total number of files over all classes: %d\n',sum(n));


fprintf('   j   k                            MC    Size       N       L       M   t(MC)\n');
for j=1:length(categories)
    k = indices(j);
    
    sz = motionTemplateBatchInfo(k).files_num;
    N = length(motionTemplateBatchInfo(k).used);
    L = mean(MC_files_frame_length{k}(motionTemplateBatchInfo(k).used));
    M = template_stats(k).iter_num;
    t = sum(template_stats(k).iter_running_time);
    fprintf('%4d',j);
    fprintf('%4d',k);
    fprintf('%30s',MC_categories{k});
    fprintf('%8d',sz);
    fprintf('%8d',N);
    fprintf('%8.1f',L);
    fprintf('%8d',M);
    fprintf('%8.1f\n',t);
end

