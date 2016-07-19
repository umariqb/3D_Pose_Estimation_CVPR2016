%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generation of motion template
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Utemplate,UtemplateWeights,Vcost] = new_motionTemplateGenerateReal_realInputWeighted(U,Uweights,parameter)
% function [Utemplate,UtemplateWeights,Vcost] = new_motionTemplateGenerateReal_realInputWeighted(U,parameter,Uweights_in) 

numU = size(U,1);
dimU = size(U{1},1);
lenV = size(U{1},2);

if (parameter.VrepWoverlapFactor<=0)
    parameter.VrepWoverlapFactor = 1/(numU-1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DTW computatation: U{1} with U{2},...,U{numU}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VrepW  =  cell(numU,1);
Vmatch =  cell(numU,1);
Vcost  =  zeros(numU,1);
UwarpWeights = zeros(numU,lenV);
UwarpWeights(1,:) = Uweights{1};
Uwarp = cell(numU,1);
Uwarp{1}=U{1};

for k=2:numU
    [Uwarp{k},UwarpWeights(k,:),VrepW{k},Vmatch{k},Vcost(k)] = new_motionTemplateDTWReal_realInputWeighted(U{1},Uweights{1},U{k},Uweights{k},parameter);
end


if (parameter.templateComputationStrategy == 6) || (parameter.templateComputationStrategy == 8)
    % only idendical values are kept. Everythind else is set to 0.5
    UtemplateHelp = Uwarp{1};
    for k=2:numU
      differences = find(UtemplateHelp ~= Uwarp{k});
      UtemplateHelp(differences) = 0.5*ones(size(differences));
    end
    %finally average all weights.
    UtemplateHelpWeights = sum(UwarpWeights,1);
    UtemplateHelpWeights = UtemplateHelpWeights/numU;

else %use real averaging
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Utemplate
    % Compute the weighted average over all templates that were generated in the 
    % preceding step. Note that all templates have the length of the reference 
    % stream V==U{1}.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    UtemplateHelp = zeros(size(U{1}));
    UtemplateHelpWeights = sum(UwarpWeights,1);
    for k=1:numU
        X = repmat(UwarpWeights(k,:),dimU,1);    
        UtemplateHelp = UtemplateHelp + X.*Uwarp{k};
    end
    X = repmat(UtemplateHelpWeights,dimU,1);
    UtemplateHelp = UtemplateHelp./X;
    UtemplateHelpWeights = UtemplateHelpWeights/numU;
end


if (parameter.conjoin == 0)
    Utemplate = UtemplateHelp;
    UtemplateWeights = UtemplateHelpWeights;
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % VrepWConjoin
    % All data streams U_i for i=2:numU have been aligned with the reference stream
    % V==U_1. Multiple matching frames from a U_i to a frame in V have been
    % recorded in the VrepW{i}, each entry of which represents a segment in V.
    % Now find the "connected components" of these segments within V.
    % That is, find longest contiguous segments within V such that there is a 
    % covering with overlapping segments from the VrepW{i}, where two
    % segments A and B are "overlapping" if there is a sequence of segments that 
    % connects A and B through simple overlap relations.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    VrepWconcat = VrepW{2};
    for k=3:numU
        VrepWconcat = [VrepWconcat VrepW{k}];
    end
    num = size(VrepWconcat,2);
    VrepWconjoin = zeros(2,num);
    [a,b] = sort(VrepWconcat(1,:));
    VrepWconcat = VrepWconcat(:,b);
    
    X = VrepWconcat;
    B = zeros(size(X,2),max(max(VrepWconcat)));
    s = (numU-1)*ones(size(B,2),1);
    s(1) = 0;
    p = X(1,1);
    for k=1:size(X,2)
        B(k,X(1,k):X(2,k)) = 1;
        if (X(1,k)~=p) % this code will execute each time a new block of start indices begins
            p = X(1,k);
            s(p) = sum(B(1:k-1,p));
        end
    end
    
    % visualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if parameter.visVrepW == 1
        %X = VrepWconcat(:,(VrepWconcat(1,:)~=VrepWconcat(2,:)));
        figure; 
        subplot(2,2,1);
        xlabel('VrepWconcat');
        imagesc(B,[0 1]);
        colormap hot;
        
        subplot(2,2,2);
        xlabel('Column sums over VrepWconcat');
        b = sum(B);
        plot(b);
        set(gca,'xlim',[1 length(b)]);
        
        subplot(2,2,3);
        xlabel('Upward column sums at lower contour');
        plot(s);
        line([1 length(b)],[parameter.VrepWoverlapFactor*(numU-1) parameter.VrepWoverlapFactor*(numU-1)],'color','r');
        set(gca,'xlim',[1 length(b)],'ylim',[0 numU]);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % counter = 0;
    % k = 0;
    % while k<num
    %     k = k+1;
    %     pos1 = VrepWconcat(1,k);
    %     pos2 = VrepWconcat(2,k);        
    %     while k<num && VrepWconcat(1,k+1)<=pos2        
    %         k = k+1;
    %         pos2 = max(pos2,VrepWconcat(2,k));
    %     end
    %     counter = counter+1;
    %     VrepWconjoin(1,counter)=pos1;
    %     VrepWconjoin(2,counter)=pos2;
    % end
    % VrepWconjoin = VrepWconjoin(:,1:counter);
    
    v = find(s<parameter.VrepWoverlapFactor*(numU-1))';
    w = [v(2:end)-1 size(B,2)];
    VrepWconjoin = [v; w];
    
    % visualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if parameter.visVrepW == 1
        B = zeros(size(VrepWconjoin,2),max(max(VrepWconjoin)));
        for k=1:size(VrepWconjoin,2)
            B(k,VrepWconjoin(1,k):VrepWconjoin(2,k)) = 1;
        end
        
        subplot(2,2,4);
        xlabel('VrepWconjoin');
        imagesc(B,[0 1]);
        colormap hot;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % UtemplateConjoin
    % Now that a segmentation of V has been determined (VrepWconjoin),
    % compute the weighted average of the columns within Utemplate corresponding to each 
    % of these segments, resulting in UtemplateConjoin.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    UtemplateWeights = zeros(1,size(VrepWconjoin,2));
    Utemplate = zeros(dimU,size(VrepWconjoin,2));
    for k=1:size(VrepWconjoin,2)
        X = repmat(UtemplateHelpWeights(VrepWconjoin(1,k):VrepWconjoin(2,k)),dimU,1);
        pattern = sum(X.*UtemplateHelp(:,VrepWconjoin(1,k):VrepWconjoin(2,k)),2);
        UtemplateWeights(k) = UtemplateWeights(k) + sum(UtemplateHelpWeights(VrepWconjoin(1,k):VrepWconjoin(2,k)));
        pattern = pattern/UtemplateWeights(k);
        Utemplate(:,k) = pattern;
    end
%     for k=1:size(VrepWconjoin,2)
%         pattern = sum(UtemplateHelp(:,VrepWconjoin(1,k):VrepWconjoin(2,k)),2);
%         UtemplateWeights(k) = UtemplateWeights(k) + sum(UtemplateHelpWeights(VrepWconjoin(1,k):VrepWconjoin(2,k)));
%         pattern = pattern/(VrepWconjoin(2,k)-VrepWconjoin(1,k)+1);
%         Utemplate(:,k) = pattern;
%     end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Visualization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if parameter.visTemplate == 1
    figure;
    set(gcf,'Position',[55    70   560   861]);
    subplot(6,1,1);
    plot(UtemplateHelpWeights);
    title('UtemplateHelp');
    colorbar;
    subplot(6,1,2);
    colormap(hot);    
    imagesc(UtemplateHelp,[0 1]);    
    colorbar;
    subplot(6,1,3);
    plot(UtemplateWeights);
    title('Utemplate');
    colorbar;
    subplot(6,1,4);
    colormap(hot);    
    imagesc(Utemplate,[0 1]);    
    colorbar;
    drawnow;
end
