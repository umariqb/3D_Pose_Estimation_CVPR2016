function tab_retrieval(search_DB, pattern_DB)

global VARS_GLOBAL;

close all;

if nargin < 2
    search_DB = 'HDM05_cut_amc';
    pattern_DB = 'HDM05_cut_amc';
%     search_DB = 'HDM05_cut_c3d';
%     pattern_DB = 'HDM05_cut_c3d';
end

% basedir_templates = fullfile('HDM','Training','_templates','');
basedir_templates = fullfile(pattern_DB, '_templates','');
downsampling_fac = 4;
sampling_rate_string = num2str(120/downsampling_fac);
%settings = ['5_0_' sampling_rate_string '_all_training'];
settings = ['5_0_' sampling_rate_string];

feature_set = {'AK_upper','AK_lower','AK_mix'};

% load bd_motion_classes
load all_motion_classes
class_info = motion_classes;
% class_info = {'rotateArmsLBackward1Reps'};

compute_hits = true;
%compute_hits = false;

% compute_confusion = true;
compute_confusion = false;

% latex = true;
latex = false;

retrievePlainDTW = true;            % switch off keyframe technique
%retrievePlainDTW = false;          % use keyframes

keyframesThreshLo = 0.1;
par.thresh_lo = keyframesThreshLo;
par.thresh_hi = 1-par.thresh_lo;

if (compute_hits)
    num_motion_classes = length(class_info);
    parameter.feature_set_ranges = {1:14,15:26,27:39};
    if (iscell(feature_set))
        feature_set_name = '';
        for i=1:length(feature_set)
            if (i==1)
                feature_set_name = feature_set{i};
            else
                feature_set_name = [feature_set_name '_' feature_set{i}];
            end
        end
    else
        feature_set_name = feature_set;
    end     
    
    %%%%%% load DB and indexes
    if (~retrievePlainDTW)
        [DB_concat,indexArray] = DB_index_load(search_DB,feature_set,downsampling_fac);
    else
        DB_concat = DB_index_load(search_DB,feature_set,downsampling_fac); % don't need index
    end

    clear results
    for k=1:num_motion_classes
        category = class_info{k};
        fprintf('\n%2d / %2d: motion class %s\n',k,num_motion_classes,category);        
        
        %%%% load and threshold motion template
        [motionTemplateReal,motionTemplateWeights] = motionTemplateLoadMatfile(basedir_templates,category,feature_set,settings);
        feature_set_ranges = parameter.feature_set_ranges;
        
        % motionTemplate = motionTemplate(:,25:end);
        % motionTemplateWeights = motionTemplateWeights(:,25:end);
        
        param.thresh_lo = 0.1;
        param.thresh_hi = 1-param.thresh_lo;
        param.visBool = 0;
        param.visReal = 0;
        param.visBoolRanges = 0;
        param.visRealRanges = 0;
        param.feature_set_ranges = feature_set_ranges;
        param.feature_set = feature_set;
        param.flag = 0;
        [motionTemplate,weights] = motionTemplateBool(motionTemplateReal,motionTemplateWeights,param);
        disp(['Length of motion template = ' num2str(size(motionTemplate,2)) ' frames.']);
        
        skip_to_next_MC = false;
        num_tries = 1;
        max_num_tries = 20;
%        keyframesScoreMin = 0.9;
        keyframesThreshLo = 0.1;
        num_keyframes_to_find = 1;
        if (~retrievePlainDTW)
            while (num_tries < max_num_tries  & ~skip_to_next_MC)
                if (num_tries>1)
                    disp(['Initiating retry no. ' num2str(num_tries-1) '.']);
                    %                keyframesScoreMin = keyframesScoreMin - 0.025;
                    keyframesThreshLo = keyframesThreshLo + 0.01;
                end
                %%% determine keyframes
                par.vis = 0;
                par.keyframesNumMax = 8;
                %            par.keyframesScoreMin = keyframesScoreMin;
                par.keyframesScoreMin = 0.9;
                par.thresh_lo = keyframesThreshLo;
                par.thresh_hi = 1-par.thresh_lo;
                par.conv = 1;
                par.feature_set_ranges = feature_set_ranges;
                par.feature_set = feature_set;
                par.keyframeMinDist = 5;
                num_keyframes_found = 0;
                %            while (num_keyframes_found < num_keyframes_to_find & keyframesScoreMin>=0.01)
                while (num_keyframes_found < num_keyframes_to_find & keyframesThreshLo<0.2)
                    [motionTemplateKeyframes, motionTemplateKeyframesIndex] = keyframesChoose2(motionTemplateReal,motionTemplateWeights,par);
                    num_keyframes_found = length(motionTemplateKeyframes);
                    if (num_keyframes_found < num_keyframes_to_find)
                        %                     par.keyframesScoreMin = par.keyframesScoreMin - 0.025;
                        %                     keyframesScoreMin = par.keyframesScoreMin;
                        par.thresh_lo = par.thresh_lo + 0.01;
                        par.thresh_hi = 1-par.thresh_lo;
                        keyframesThreshLo = par.thresh_lo;
                    end
                end
                mismatch = ones(1,length(motionTemplateKeyframes));
                %mismatch = zeros(1,length(motionTemplateKeyframes));
                
                if (num_keyframes_found>0)
                    %                disp(['Found ' num2str(num_keyframes_found) ' keyframes, keyframesScoreMin = ' num2str(par.keyframesScoreMin) '.']);
                    disp(['Found ' num2str(num_keyframes_found) ' keyframes, keyframesThreshLo = ' num2str(par.thresh_lo) '.']);
                    maxKeyframeSep = 2*(motionTemplateKeyframes(end)-motionTemplateKeyframes(1)+1);
                    extendLeft = 3*(motionTemplateKeyframes(1));
                    extendRight = 3*(size(motionTemplate,2) - motionTemplateKeyframes(end));
                    
                    tic
                    [segments,framesTotalNum,matchStart,match] = keyframeSequenceFindMultIndexMismatch(motionTemplate,[motionTemplateKeyframes; motionTemplateKeyframesIndex; mismatch],maxKeyframeSep,extendLeft,extendRight,indexArray);    
                    t_keyframe = toc;
                    
                    if (isempty(segments))
                        disp(['segments was empty.']);
                        skip_to_next_MC = true;
                        continue;
                    end
                    disp(['Found ' num2str(size(segments,2)) ' segments.']);
                    
                    try    
                        clear DB_cut;
                        [DB_cut,segments_cut] = featuresCut(DB_concat,segments,indexArray(1),framesTotalNum,2);
                    catch
                        if (num_tries < max_num_tries)
                            num_tries = num_tries + 1;
                            num_keyframes_to_find = num_keyframes_found + 1;
                            skip_to_next_MC = false;
                            continue;
                        else
                            disp(['Out of memory during feature concatenation.']);
                            skip_to_next_MC = true;
                            continue;
                        end
                    end
                    disp(['Length of DB_cut = ' num2str(size(DB_cut.features,2)) ' frames.']);
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    parameter.visCost      = 0;
                    parameter.match_numMax = 500;
                    parameter.match_thresh = 0.15;
                    parameter.match_endExclusionForward = 0.1;
                    parameter.match_endExclusionBackward = 0.5;
                    parameter.match_startExclusionForward = 0.5;
                    parameter.match_startExclusionBackward = 0.1;
                    parameter.expandV = 1;
                    parameter.normalizeGray = 1;
                    try
                        tic
                        [hits] = motionTemplateDTWRetrievalWeighted(motionTemplate,weights,DB_cut.features,ones(1,size(DB_cut.features,2)),parameter,...
                            [1 1 2],[1 2 1],[1 1 2]);
                        t_DTW = toc;
                    catch
                        try
                            clear DB_concat;
                            clear indexArray;
                            tic
                            [hits] = motionTemplateDTWRetrievalWeighted(motionTemplate,weights,DB_cut.features,ones(1,size(DB_cut.features,2)),parameter,...
                                [1 1 2],[1 2 1],[1 1 2]);
                            t_DTW = toc;
                            clear DB_cut;
                            [DB_concat,indexArray] = DB_index_load(search_DB,feature_set,downsampling_fac);
                        catch   
                            clear DB_cut;
                            [DB_concat,indexArray] = DB_index_load(search_DB,feature_set,downsampling_fac);
                            if (num_tries < max_num_tries)
                                num_tries = num_tries + 1;
                                num_keyframes_to_find = num_keyframes_found + 1;
                                skip_to_next_MC = false;
                                continue;
                            else
                                disp(['Out of memory during retrieval.']);
                                skip_to_next_MC = true;
                                continue;
                            end
                        end
                    end
                    disp(['Found ' num2str(length(hits)) ' hits.']);
                    [hits_cut,hits] = hits_DTW_postprocessSegments(hits,DB_cut,segments_cut,DB_concat,segments);
                    skip_to_next_MC = true;
                else
                    disp(['motionTemplateKeyframes was empty.']);
                    skip_to_next_MC = true;
                end
            end
        else
            parameter.visCost      = 0;
            parameter.match_numMax = 500;
            parameter.match_thresh = 0.1;
            parameter.match_endExclusionForward = 0.1;
            parameter.match_endExclusionBackward = 0.5;
            parameter.match_startExclusionForward = 0.5;
            parameter.match_startExclusionBackward = 0.1;
            parameter.expandV = 1;
            parameter.normalizeGray = 1;

            framesTotalNum = size(DB_concat.features,2);
            
            if size(motionTemplate,2)==0
                hits=[];
                t_DTW = 0;
                disp('Empty motion template!');
            else
           % try
                tic
                [hits] = motionTemplateDTWRetrievalWeighted(motionTemplate,weights,DB_concat.features,ones(1,size(DB_concat.features,2)),parameter,...
                    [1 1 2],[1 2 1],[1 1 2]);
                t_DTW = toc;
                %catch
                %disp(['Out of memory during retrieval.']);
                %end
                disp(['Found ' num2str(length(hits)) ' hits.']);
                hits = hits_DTW_postprocess(hits,DB_concat);
            end
        end
        results(k).category = category;
        results(k).num_template_frames = size(motionTemplate,2);
        results(k).hits = hits;
        results(k).framesTotalNum = framesTotalNum;
        if (retrievePlainDTW)
            results(k).t_keyframe = 0;
        else
            results(k).t_keyframe = t_keyframe;
        end
        results(k).t_DTW = t_DTW;
    end
    
    save(['retrieval_results_' search_DB '_' pattern_DB '_' num2str(1000*par.thresh_lo)],'results');
else
    load(['retrieval_results_' search_DB '_' pattern_DB '_' num2str(1000*par.thresh_lo)]);
end

if (latex)
    fid = fopen(['tab_retrieval_' search_DB '_' pattern_DB '.tex'],'w');
    fprintf(fid,'\\begin{table}[t]\n');
    fprintf(fid,'\\setlength{\\tabcolsep}{0.8ex}\n');
    fprintf(fid,'\\begin{center}\n');
    fprintf(fid,'\\small\n');
    fprintf(fid,'\\renewcommand{\\arraystretch}{0.5}\n');
    fprintf(fid,'\\begin{tabular}{|l|c|*{6}{c}|c|r|}\n');
    fprintf(fid,'\\hline\n');
    fprintf(fid,'{ Motion Class C} & $\\gamma$ & \\multicolumn{6}{c|}{$|H_{\tau}|$ \\,\\, / \\,\\, $|H_{\\tau}^+|$} & $K$ & $t(\\Delta_C)$\\\\\n');
    fprintf(fid,'\\hline \\hline\n');
% else
%     fprintf('\n id                   motion class  nTmpFr rel  ret relRet     r     p  r005  p005   r01   p01  r025  p025    nFrKF    tKF   tDTW\n');
end
fprintf('\n id                   motion class  nTmpFr rel  ret relRet     r     p  r005  p005   r01   p01  r025  p025    nFrKF    tKF   tDTW\n');

tau = [0.01 0.02 0.04 0.06 0.08 0.1];
for k=1:num_motion_classes
    warning off MATLAB:divideByZero
    
    category        = results(k).category;
    num_template_frames = results(k).num_template_frames;
    hits            = results(k).hits;
    framesTotalNum  = results(k).framesTotalNum;
    t_keyframe      = results(k).t_keyframe;
    t_DTW           = results(k).t_DTW;

    num_relevant = 0;
    filenames_relevant = cell(length(DB_concat.files_name),1);
    for d=1:length(DB_concat.files_name)
        I = findstr(DB_concat.files_name{d},category);
        if (~isempty(I))
            num_relevant = num_relevant+1;
            filenames_relevant{num_relevant} = DB_concat.files_name{d};
        end
    end
    filenames_relevant = filenames_relevant(1:num_relevant);

    if (latex)
        fprintf(fid,'\\multirow{2}{*}{%30s} & \\multirow{2}{*}{%4d} & ',category,num_relevant);
%     else
%         fprintf('%4d %30s %6d %4d ',k,category,num_template_frames,num_relevant);
    end
    fprintf('%4d %30s %6d %4d ',k,category,num_template_frames,num_relevant);
    
    num_retrieved = zeros(1,length(tau));
    num_relevant_retrieved = zeros(1,length(tau));
    for i=1:length(tau)
        h = hits(find([hits.cost]<=tau(i)));
        num_retrieved(i) = length(h);
        filenames_retrieved = {h.file_name}';
        [x,I] = intersect(filenames_relevant,filenames_retrieved);
        num_relevant_retrieved(i) = length(I);
    end
    
    if (latex)
        fprintf(fid,'\n');
        fprintf(fid,'{\\tiny %4d} & ',num_retrieved);
        fprintf(fid,'\n');
        fprintf(fid,'\\multirow{2}{*}{%6d} & \\multirow{2}{*}{%6.2f} \\\\ & & \n',num_template_frames,t_DTW);
        fprintf(fid,'{\\tiny %4d} & ',num_relevant_retrieved);
        fprintf(fid,'& \\\\\n\\hline\n');
%     else
%         fprintf('%4d %4d ',num_retrieved,num_relevant_retrieved);
%         fprintf(' %8d %6.2f %6.2f\n',framesTotalNum,t_keyframe,t_DTW);
    end
    fprintf('%4d %4d ',num_retrieved,num_relevant_retrieved);
    fprintf(' %8d %6.2f %6.2f\n',framesTotalNum,t_keyframe,t_DTW);
end
if (latex)
    fprintf(fid,'\\end{tabular}\n');
    fprintf(fid,'\\end{center}\n');
    fprintf(fid,'\\caption[kurzes Bla]{Suche in HDM05\\_cut\\_amc mit Templates aus HDM05\\_cut\\_amc}\n');
    fprintf(fid,'\\end{table}\n');
    fclose(fid);
end

if (compute_confusion)
    confusion = zeros(num_motion_classes,num_motion_classes);
    tau = 0.06;
    for k=1:num_motion_classes
        hits            = results(k).hits;
        
        h = hits(find([hits.cost]<=tau));
        num_retrieved = length(h);
        filenames_retrieved = {h.file_name}';
        
        for j=1:num_motion_classes
            num_relevant = 0;
            filenames_relevant = cell(length(DB_concat.files_name),1);
            for d=1:length(DB_concat.files_name)
                I = findstr(DB_concat.files_name{d},class_info{j});
                if (~isempty(I))
                    num_relevant = num_relevant+1;
                    filenames_relevant{num_relevant} = DB_concat.files_name{d};
                end
            end
            filenames_relevant = filenames_relevant(1:num_relevant);
            [x,I] = intersect(filenames_relevant,filenames_retrieved);
            confusion(k,j) = length(I);
        end
        confusion(k,:) = confusion(k,:)/sum(confusion(k,:));
    end
    
    figure
    imagesc(confusion);
    axis equal; axis tight; axis xy;
    set(gca,'xtick',[1:num_motion_classes]);
    set(gca,'ytick',[1:num_motion_classes]);
    colorbar;
    printName = ['print/fig_confusion_' search_DB '_' pattern_DB '_tau_' num2str(100*tau) '.eps'];
    print('-depsc2',printName);
end