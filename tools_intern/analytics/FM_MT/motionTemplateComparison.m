function [diffMT, diffMTperFeature, MTlengths] = motionTemplateComparison( compFunction, DB1, DB2, categories, showGraphics)

if (nargin < 2) || isempty(DB1)
    DB1 = 'HDM05_cut_amc_dipl';
    DB2 = 'HDM05_cut_c3d_dipl';
end

if nargin < 4 % demo mode :)
    load HE_motion_classes;
    categories = motion_classes;
%     categories = {'depositLowR'};
end

if nargin < 5
    showGraphics = false;
end

easymode = true;
        

% get MTs
downsampling_fac = 4;
sampling_rate_string = num2str(120/downsampling_fac);
settings = ['5_0_' sampling_rate_string];
feature_set = {'AK_upper','AK_lower','AK_mix'};
feature_set_ranges = {1:14,15:26,27:39};

basedir_templates1 = fullfile(DB1,'_templates','');
basedir_templates2 = fullfile(DB2,'_templates','');

for cat=1:length(categories)
    category = categories{cat};
    [motionTemplateReal1, motionTemplateWeights1] = motionTemplateLoadMatfile(basedir_templates1, category, feature_set, settings);
    [motionTemplateReal2, motionTemplateWeights2] = motionTemplateLoadMatfile(basedir_templates2, category, feature_set, settings);
    
    param.thresh_lo = 0.1;
    param.thresh_hi = 1-param.thresh_lo;
    param.visBool = 0;
    param.visReal = 0;
    param.visBoolRanges = 0;
    param.visRealRanges = 0;
    param.feature_set_ranges = feature_set_ranges;
    param.feature_set = feature_set;
    param.flag = 0;
    
    [motionTemplate1, weights1] = motionTemplateBool(motionTemplateReal1, motionTemplateWeights1, param);
    [motionTemplate2, weights2] = motionTemplateBool(motionTemplateReal2, motionTemplateWeights2, param);
    
    MTlengths(cat,1) = size(motionTemplate1,2);
    MTlengths(cat,2) = size(motionTemplate2,2);
    
    if strcmpi(compFunction, 'mtdiff')
        minLen = min(size(motionTemplate1, 2), size(motionTemplate2, 2));
        
        diffMT(cat) = sum(sum(abs(motionTemplate1(:,1:minLen) - motionTemplate2(:,1:minLen)))) / minLen / size(motionTemplate1,1);
        diffMTperFeature(cat,:) = sum(abs(motionTemplate1(:,1:minLen) - motionTemplate2(:,1:minLen)),2)' / minLen;

        if (showGraphics && length(categories) < 5)
            showTemplateComparison( category, DB1, DB2, true, false );
        end
        
    elseif strcmpi(compFunction, 'mtdtw')
        
%         function [hits,C,D,Delta]=motionTemplateDTWRetrievalWeighted(V,Vweights,W,Wweights,parameter,varargin)
        di = [1 1 2];
        dj = [1 2 1];
%         di = [1 0 1];
%         dj = [1 1 0];
%         dWeights = [1 1 1];
%         di = [1 1 2];
%         dj = [1 2 1];
        dWeights = [1 1 2];
%         DB_concat = DB_index_load(DB1, feature_set, downsampling_fac); 
%         motionDatabase = DB_concat.features;
        
        V = motionTemplate1;
        Vweights = weights1;
        [V,Vweights] = expandWeightedVectorSequence(V, Vweights);

        W = motionTemplate2;
        Wweights = weights2;
        [W,Wweights] = expandWeightedVectorSequence(W, Wweights);
        
%         W = motionDatabase;
%         Wweights = ones(1,size(motionDatabase,2))
        
        V = V';
        W = W';
        
        n = size(V,1);
        p = size(V,2);
        m = size(W,1);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Global cost matrix for matching i-th feature with j-th feature
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         V_0 = double(V==0)+double(V==0.5);
%         V_1 = double(V==1)+double(V==0.5);
%         
%         C = V_1*W' + V_0*(1-W');             % #(concurrences)

        V_0  = double(V==0);
        V_1  = double(V==1);
        V_05 = double(V==0.5);

        W_0  = double(W==0);
        W_1  = double(W==1);
        W_05 = double(W==0.5);

        %  val1 / val2 -> costs :
        %   0/0 -> 1,    1/1 -> 1,    0.5/0.5 -> 1,  0.5/0 -> 0.5,     0/0.5 -> 0.5,     0.5/1 -> 0.5,     1/0.5 -> 0.5
        C = V_0 * W_0' + V_1 * W_1' + V_05 * W_05' + 0.5*V_05 * W_0' + 0.5*V_0 * W_05' + 0.5*V_05 * W_1' + 0.5*V_1 * W_05';

        C = p-C;                             % #(disagreements)
        C = C/n;                             % disagreements per frame in V

        if easymode
            match = computeWarpingPath(C, true);
            wpcosts=0; 
            for i=1:length(match)
                wpcosts=wpcosts + C(match(i,1), match(i,2)); 
            end
            diffMT(cat) = wpcosts/p;
            diffMTperFeature = [];
            continue;
        end
        
        %C = C/(p*n);                        % disagreements per feature and frame in V
        %C = C_DTW_compute_C(V,W); % slower
        num_V_nonfuzzy = max(1,sum(V~=0.5,2));
        C = C.*((repmat(Vweights',1,m)+repmat(Wweights,n,1))./(2*repmat(num_V_nonfuzzy,1,m)));
        %C = C.*((repmat(Vweights',1,m)+repmat(Wweights,n,1))/2);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Computing optimal match by dynamic programming
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         tic;
%         D = zeros(n,m);
%         E = zeros(n,m);
%         
%         D(1,1) = C(1,1);
%         for i=2:n
%             D(i,1)=D(i-1,1)+C(i,1);
%         end
%         for j=2:m
%             D(1,j)=C(1,j);
%         end
%         
%         for i=2:n
%             for j=2:m
%                 indices = sub2ind(size(D),max(i-di,1),max(j-dj,1));
%                 [val,E(i,j)] = min(D(indices));
%                 
%                 D(i,j) = val + dWeights(E(i,j))*C(i,j);
%             end
%         end
        
        %%%%%%%% equivalent C code, improves efficiency by roughly a factor of 150
        [D,E] = C_DTWpartial_compute_D_variablePathSteps(C,int32(di),int32(dj),dWeights);
%         figure, imagesc(E), figure, imagesc(D);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %t=toc; fprintf('%f',t)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Matches
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Delta = D(n,:);    
        
        parameter.match_numMax = 10;
        parameter.match_thresh = 10;
        parameter.match_endExclusionForward = 0.1;
        parameter.match_endExclusionBackward = 0.5;
        parameter.match_startExclusionForward = 0.5;
        parameter.match_startExclusionBackward = 0.1;
        
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
        
        matches_length = zeros(1,length(Delta)); % this array will indicate the length (in frames) of the match starting at a specific point
        Delta_help = Delta;
        counter = 0;
        [cost,pos] = min(Delta_help);
        while counter<match_numMax && cost <= match_thresh
            i=n;
            j=pos;
            match_temp = zeros(max(n,m),2);
            k=0;
            while ((i>1) & (j>1))
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
            
            if (matches_length(match_temp(2,1))>0) % has the starting point of this path been recorded previously?
                current_match_length = matches_length(match_temp(2,1));
            else % new starting point of a match path; record match.
                counter = counter+1;
                hits(counter).match = match_temp;
                hits(counter).frame_first_matched_all =  match_temp(2,1);
                hits(counter).frame_last_matched_all = match_temp(2,end);
                hits(counter).cost = cost;
                
                current_match_length = match_temp(2,end)-match_temp(2,1)+1;
                
                pufferBackward = ceil(parameter.match_startExclusionBackward*current_match_length);
                pufferForward = ceil(parameter.match_startExclusionForward*current_match_length);
                ind_start = max(match_temp(2,1)-pufferBackward,1);
                ind_end   = min(match_temp(2,1)+pufferForward,m);
                matches_length(ind_start:ind_end) = repmat(current_match_length,1,ind_end-ind_start+1);
            end
            
            pufferBackward = ceil(parameter.match_endExclusionBackward*current_match_length);
            pufferForward = ceil(parameter.match_endExclusionForward*current_match_length);
            ind_start = max(match_temp(2,end)-pufferBackward,1);
            ind_end   = min(match_temp(2,end)+pufferForward,m);
            Delta_help(ind_start:ind_end)=Inf;
            [cost,pos] = min(Delta_help);
        end
        hits = hits(1:counter);
%         hits = hits_DTW_postprocess(hits,DB_concat,downsampling_fac);

        
        diffMT(cat) = hits(1).cost;
        diffMTperFeature = [];
%         disp(num2str(wpcosts - diffMT(cat)));
        
        if showGraphics
            figure;
            imagesc(C);
            axis xy; axis equal;
            set(gca,'xlim',[1 size(C,2)],'ylim',[1 size(C,1)]);
%             set(gca, 'position', [ 0.05    0.1    0.83    0.83])
            colormap(hot);
            colorbar;
            cBarPos = get(colorbar, 'position');
            set(colorbar, 'position', cBarPos .* [1 1 0.5 1]);
%             set(colorbar, 'position', [0.77 0.1 0.03 0.83]);
            hold;
            h = plot(match(:,2),match(:,1));
            set(h,'Color',[0.5 1 1]);
            set(h, 'LineWidth', 2)
            set(gcf, 'name', category);
        end
        
    end
end
diffMTperFeature = diffMTperFeature';

