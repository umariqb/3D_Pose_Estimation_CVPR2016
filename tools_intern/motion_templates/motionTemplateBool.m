function [motionTemplate,motionTemplateWeights] = motionTemplateBool(motionTemplateReal,motionTemplateWeights,parameter)
% [motionTemplate,motionTemplateWeights] = motionTemplateBool(motionTemplateReal,motionTemplateWeights,parameter)
% flag = 0: no time adaptation
% flag = 1: time adaptation
% flag = 2: time adaptation and successive expansion
%
% parameter.vis

flag = parameter.flag;
thresh_lo = parameter.thresh_lo;
thresh_hi = parameter.thresh_hi;
feature_set_ranges = parameter.feature_set_ranges;
feature_set = parameter.feature_set;

%read labels for template figures
Ylabels={};

if (parameter.visReal)
    figure; 
    subplot(2,1,1); plot(motionTemplateWeights); 
    if (size(motionTemplateWeights,2)>1) 
        set(gca,'xlim',[1 size(motionTemplateWeights,2)]); 
    end
    colorbar; drawnow;
    subplot(2,1,2); imagesc(motionTemplateReal,[0 1]); colormap hot; colorbar; drawnow;
    set(gcf,'pos',[40   463   560   420]);
end

if (parameter.visRealRanges)
    figure; 
    num_ranges = length(feature_set_ranges);
%     subplot(num_ranges+1,1,1); plot(motionTemplateWeights); 
%     if (size(motionTemplateWeights,2)>1) 
%         set(gca,'xlim',[1 size(motionTemplateWeights,2)]); 
%     end
%     drawnow;
    for k=1:num_ranges
        subplot(num_ranges,1,k); imagesc(motionTemplateReal(feature_set_ranges{k},:),[0 1]);
        h = ylabel(feature_set{k});
        set(h,'interpreter','none');
        fspec=load(['fspec_' feature_set{k} '.mat']);
        num=size(feature_set_ranges{k});
        fsr=feature_set_ranges{k};
        for l=1:num(2)
           Ylabels(1,l)={fspec.features_spec(fsr(l)).name};
        end
        set(gca,'YTickLabel',Ylabels);    
    end
    colormap hot; drawnow;
    set(gcf,'pos',[40   463   560   420]);
end

motionTemplate = motionTemplateReal;
motionTemplate(motionTemplate>thresh_lo & motionTemplate<thresh_hi) = 0.5;
motionTemplate(motionTemplate<=thresh_lo) = 0;
motionTemplate(motionTemplate>=thresh_hi) = 1;

if (flag == 1 | flag == 2)
    [motionTemplate,motionTemplateWeights] = motionTemplate_eliminateDuplicateColumnsWeighted(motionTemplate,motionTemplateWeights);
end

if (flag == 2)
    [motionTemplate,motionTemplateWeights] = expandWeightedVectorSequence(motionTemplate,motionTemplateWeights);
end

if (parameter.visBool)
    figure; 
    subplot(2,1,1); plot(motionTemplateWeights); 
    if (size(motionTemplateWeights,2)>1) 
        set(gca,'xlim',[1 size(motionTemplateWeights,2)]); 
    end
    colorbar; drawnow;
    subplot(2,1,2); imagesc(motionTemplate,[0 1]); colormap gray; colorbar; drawnow;
    set(gcf,'pos',[650   463   560   420]);
end

if (parameter.visBoolRanges)
    figure; 
    num_ranges = length(feature_set_ranges);
%     subplot(num_ranges+1,1,1); plot(motionTemplateWeights); 
%     if (size(motionTemplateWeights,2)>1) 
%         set(gca,'xlim',[1 size(motionTemplateWeights,2)]); 
%     end
%     drawnow;
    for k=1:num_ranges
        subplot(num_ranges,1,k); imagesc(motionTemplate(feature_set_ranges{k},:),[0 1]);
        h = ylabel(feature_set{k});
        set(h,'interpreter','none');  
        set(gca,'YTickLabel',Ylabels);
    end
    colormap gray; drawnow;
    set(gcf,'pos',[650   463   560   420]);
end
