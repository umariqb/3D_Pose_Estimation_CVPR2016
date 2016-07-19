function [motionTemplate,motionTemplateWeights,motionTemplateKeyframes,statistics] = motionTemplateGenerateDTWIterative(parameter,varargin)
% [motionTemplate,motionTemplateWeights,motionTemplateKeyframes,statistics] = motionTemplateGenerateDTWIterative(parameter,pathname,matfilename)
%
% parameter.basedir;
% parameter.category;
% parameter.files;
% parameter.feature_set;
% parameter.downsampling_fac;
% parameter.visStatistics
% parameter.visVrepW
% parameter.visTemplateFinal
% parameter.VrepWoverlapFactor = 0.4; % parameter.VrepWoverlapFactor = 0 yields same behavior as "classical" connected components approach
% parameter.iter_max           = 10;
% parameter.iter_thresh        = 0.005;
% parameter.templateComputationStrategy = 1;

matfilename = '';
pathname = '';
if (nargin>2)
    matfilename = varargin{2};
end
if (nargin>1)
    pathname = varargin{1};
end

fullmatfilename = fullfile(pathname, matfilename);

basedir_features = parameter.basedir;
category = parameter.category;
files = parameter.files;
feature_set = parameter.feature_set;
downsampling_fac = parameter.downsampling_fac;

%%%%% prepare feature set name
feature_set_name =concatStringsInCell(feature_set);

%%%%% prepare category name
category_name = concatStringsInCell(category);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[motionTemplatesReal,filenames,feature_set_ranges] = features_decode_category(basedir_features,category,feature_set,files,downsampling_fac);
filenames_unpermuted = filenames;
I = findstr(filenames{1},filesep);

num_files = length(motionTemplatesReal);
parameter.files = 1:num_files;

if (isfield(parameter,'flip'))
    flip = parameter.flip;
    if (length(flip)<=1)
        flip = zeros(1,num_files);
    end
else
    flip = zeros(1,num_files);
end

for k=1:num_files
    if (flip(k))
        motionTemplatesReal{k} = motionTemplateFlip(motionTemplatesReal{k});
    end
end

motionTemplateWeights = cell(num_files,1);
for k=1:num_files
    motionTemplateWeights{k} = ones(1,size(motionTemplatesReal{k},2));
end

motionTemplatesReal_new = cell(num_files,1);
motionTemplatesWeights_new = cell(num_files,1);
VrepWconjoin = cell(num_files,1);
    
j = 0;
iter_error_max = parameter.iter_thresh+1;

statistics.iter_running_time = zeros(1,parameter.iter_max);
statistics.iter_error_mean = zeros(1,parameter.iter_max);
statistics.iter_error_std = zeros(1,parameter.iter_max);
statistics.iter_error_max = zeros(1,parameter.iter_max);
statistics.iter_error_thresh = parameter.iter_thresh;
statistics.iter_num = 0;

fprintf('Motion template for %s, feature set = %s, iteration/max_error: %4i/%7.5f',category_name,feature_set_name,j,iter_error_max);
iter_error_previous = 0;
while (j<parameter.iter_max && iter_error_max>parameter.iter_thresh ...
       && iter_error_previous ~= iter_error_max)
       
    iter_error_previous = iter_error_max;
    j = j+1;
    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b'); fprintf('%4i/%7.5f',j,iter_error_max); 

    Vcost = zeros(num_files,num_files);
    t = cputime;
    for k=1:num_files
        templates_reordered = [k setdiff(1:num_files,k)];

        if (parameter.templateComputationStrategy == 1) 
            % use weights in matching and perform time adaptation after each iteration
            [motionTemplatesReal_new{k},motionTemplatesWeights_new{k},VrepWconjoin{k},Vcost(:,k)] =...
                 motionTemplateGenerateReal_realInputWeighted(motionTemplatesReal(templates_reordered),parameter,motionTemplateWeights(templates_reordered));
            [motionTemplatesReal_new{k},motionTemplatesWeights_new{k}] = expandWeightedVectorSequence(motionTemplatesReal_new{k},motionTemplatesWeights_new{k});
        elseif (parameter.templateComputationStrategy == 2) 
            % use weights in matching
            [motionTemplatesReal_new{k},motionTemplatesWeights_new{k},VrepWconjoin{k},Vcost(:,k)] =...
                 motionTemplateGenerateReal_realInputWeighted(motionTemplatesReal(templates_reordered),parameter,motionTemplateWeights(templates_reordered));
        elseif (parameter.templateComputationStrategy == 3) 
            % do not use weights in matching
            [motionTemplatesReal_new{k},motionTemplatesWeights_new{k},VrepWconjoin{k},Vcost(:,k)] =...
                motionTemplateGenerateReal_realInput(motionTemplatesReal(templates_reordered),parameter,motionTemplateWeights(templates_reordered));
        elseif (parameter.templateComputationStrategy == 4) 
            % use weights in matching and perform time adaptation after each iteration
            [motionTemplatesReal_new{k},motionTemplatesWeights_new{k},Vcost(:,k)] =...
                 new_motionTemplateGenerateReal_realInputWeighted(motionTemplatesReal(templates_reordered),motionTemplateWeights(templates_reordered),parameter);
            [motionTemplatesReal_new{k},motionTemplatesWeights_new{k}] = expandWeightedVectorSequence(motionTemplatesReal_new{k},motionTemplatesWeights_new{k});
        elseif (parameter.templateComputationStrategy == 5)  
            % use weights in matching and perform balanced time adaptation after each iteration
            [motionTemplatesReal_new{k},motionTemplatesWeights_new{k},Vcost(:,k)] =...
                 new_motionTemplateGenerateReal_realInputWeighted(motionTemplatesReal(templates_reordered),motionTemplateWeights(templates_reordered),parameter);
            [motionTemplatesReal_new{k},motionTemplatesWeights_new{k}] = balanceWeightedVectorSequence(motionTemplatesReal_new{k},motionTemplatesWeights_new{k});
        elseif (parameter.templateComputationStrategy == 6)  
            % use weights in matching, perform balanced time adaptation
            % after each iteration
            % Averaging step: only keep identical values. Everything else
            % is set to 0.5
            [motionTemplatesReal_new{k},motionTemplatesWeights_new{k},Vcost(:,k)] =...
                 new_motionTemplateGenerateReal_realInputWeighted(motionTemplatesReal(templates_reordered),motionTemplateWeights(templates_reordered),parameter);
            [motionTemplatesReal_new{k},motionTemplatesWeights_new{k}] = balanceWeightedVectorSequenceLogicalAnd(motionTemplatesReal_new{k},motionTemplatesWeights_new{k});
        elseif (parameter.templateComputationStrategy == 7) 
            % do not use weights in matching
            % Averaging step: only keep identical values. Everything else
            % is set to 0.5
            [motionTemplatesReal_new{k},motionTemplatesWeights_new{k},Vcost(:,k)] =...
                motionTemplateGenerateReal_realInput(motionTemplatesReal(templates_reordered),motionTemplateWeights(templates_reordered),parameter);
        elseif (parameter.templateComputationStrategy == 8) 
            % use weights in matching
            % Averaging step: only keep identical values. Everything else
            % is set to 0.5
            % Apply the uniqueness operator: Cancel consecutive repetitions
            % in the template by merging adjacent identical columns (and
            % their weights. Don't apply expansion and contracion
            % operators afterwards.

            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % apply uniqueness operator: eleminate consecutive repetitions
            % while adding up eleminated weights. The sum of all weights
            % remains constant.
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            for kk = 1:num_files
                [motionTemplatesReal{kk}, motionTemplateWeights{kk}] = uniqueness_operator(motionTemplatesReal{kk}, motionTemplateWeights{kk});
            end
            
            [motionTemplatesReal_new{k},motionTemplatesWeights_new{k},Vcost(:,k)] =...
                 new_motionTemplateGenerateReal_realInputWeighted(motionTemplatesReal(templates_reordered),motionTemplateWeights(templates_reordered),parameter);
             
        end

        w = sum(motionTemplatesWeights_new{k}); % for sake of simplicity, all costs are normalized by the average length (==total weight) of all training motions
        
        Vcost(:,k) = Vcost(:,k) / w;
%        if (k==num_files)
%            disp(j);
%            disp(sum(sum(Vcost)));
%            disp(Vcost);
%        end
    end
    t = cputime - t;
    
    statistics.iter_error_mean(j) = mean(Vcost(:));
    statistics.iter_error_std(j) = std(Vcost(:));
    iter_error_max = max(Vcost(:));
    
    statistics.iter_error_max(j) = iter_error_max;
    statistics.iter_running_time(j) = t;

%     figure;
%     imagesc(Vcost,[0 .2]); colorbar; colormap hot; 
%     title(['mean = ' num2str(mean(Vcost(:))) ', std = ' num2str(std(Vcost(:)))]);
%     drawnow;
    
    motionTemplatesReal = motionTemplatesReal_new;
    motionTemplateWeights = motionTemplatesWeights_new;
    
    if (parameter.visIterations || (j==parameter.iter_max && parameter.visLastIteration))
        h3 = figure;
        set(h3,'position',[0 0 600 400]);
        num_files = length(files);
        subplot_size = ceil(sqrt(num_files));
        set(h3,'name',['Generation ', num2str(j), ' UtemplateConjoinReal, ', category ', ' feature_set_name]);
        colormap(hot);
        for k=1:length(files)
            subplot(subplot_size,subplot_size,k);
            drawnow;
            hi=imagesc(motionTemplatesReal{k},[0 1]); 
            colormap gray;
            set(hi,'ButtonDownFcn',{@animateOnClick,filenames_unpermuted{k}});
            ylabel(['Ref. motion ' num2str(files(k))]); 
            h=title(filenames_unpermuted{k}(I(end)+5:end-8)); set(h,'interpreter','none');
            %colorbar;
        end
        
        h4 = figure;
        set(h4,'position',[650 0 600 400]);
        set(h4,'name',['Generation ', num2str(j), ' weights']);
        for k=1:length(files)
            subplot(subplot_size,subplot_size,k);
            plot(motionTemplateWeights{k});
            if (~ishold)
                hold on;
            end
            ylabel(num2str(sum(motionTemplateWeights{k})));
            if (~isempty(VrepWconjoin{k}))
                h = VrepWconjoin{k}(2,:) - VrepWconjoin{k}(1,:) + 1;
                plot(h,'r');
            end
            if (length(motionTemplateWeights{k})>1)
                set(gca,'xlim',[1 length(motionTemplateWeights{k})]);
            end
            drawnow;
        end
    end
end
fprintf('\b\b\b\b\b\b\b\b\b\b\b\b'); fprintf('%4i/%7.5f\n',j,iter_error_max); 

motionTemplate = motionTemplatesReal{1};
motionTemplateWeights = motionTemplateWeights{1};
motionTemplateKeyframes = zeros(1,size(motionTemplate,2));

statistics.iter_num = j;
statistics.iter_error_mean =  statistics.iter_error_mean(1:j);
statistics.iter_error_std =  statistics.iter_error_std(1:j);
statistics.iter_error_max =  statistics.iter_error_max(1:j);
statistics.iter_running_time =  statistics.iter_running_time(1:j);

parameter.feature_set = feature_set;
parameter.feature_set_ranges = feature_set_ranges;

if (~isempty(fullmatfilename))
   save(fullmatfilename,'motionTemplate','motionTemplateWeights','motionTemplateKeyframes','parameter','statistics');
end

if (parameter.visTemplateFinal)
    figure; 
    subplot(2,1,1); plot(motionTemplateWeights); 
    if (size(motionTemplateWeights,2)>1) 
        set(gca,'xlim',[1 size(motionTemplateWeights,2)]); 
    end
    colorbar; drawnow;
    subplot(2,1,2); imagesc(motionTemplate,[0 1]); colormap hot; colorbar; drawnow;
    set(gcf,'pos',[40   463   560   420]);
    set(gcf,'name',matfilename);
end

if (parameter.visStatistics)
    figure;
    subplot(2,1,1);
    plot(statistics.iter_error_max);
    hold on;
    plot(statistics.iter_error_mean,'r');
    plot(statistics.iter_error_std,'g');
%     plot(log(statistics.iter_error_max));
%     hold on;
%     plot(log(statistics.iter_error_mean),'r');
%     plot(log(statistics.iter_error_std),'g');
    set(gca,'xlim',[1 j]);
    
    subplot(2,1,2);
    plot(statistics.iter_running_time*1000);
    set(gca,'xlim',[1 j]);
end