function r = comparisonRanking( DB_info, DBs, rankingVectorLength, recompute )
% r = comparisonRanking( DB_info, DBs, rankingVectorLength, recompute )

if nargin < 1
    load HDM_training_DB_info;
end

if nargin < 4
    recompute = false;
end

if (nargin < 2 || isempty(DBs))
    DBs = { {'HDM05_cut_c3d', 'HDM05_cut_c3d'} , {'HDM05_cut_amc', 'HDM05_cut_amc' }};
end    

if nargin < 3
    rankingVectorLength = 20;
end

dbs = dbstack;
fullPath = dbs(1).name(1:max(strfind(dbs(1).name, '\')));

if recompute
    
    keyframesThreshLo = 0.1;
    par.thresh_lo = keyframesThreshLo;
    par.thresh_hi = 1-par.thresh_lo;
    
    rankingVector = ([1:rankingVectorLength] - rankingVectorLength).*([1:rankingVectorLength] - rankingVectorLength) / (rankingVectorLength-1)/(rankingVectorLength-1) * (rankingVectorLength-10)  + 10;
 
    for j=1:length(DBs)
        load(fullfile(fullPath, 'Cache', ['retrieval_results_' DBs{j}{1} '_' DBs{j}{2} '_' num2str(1000*par.thresh_lo)]));
        feature_set = {'AK_upper','AK_lower','AK_mix'};
        downsampling_fac = 4;
        DB_concat = DB_index_load(DBs{j}{1},feature_set,downsampling_fac); % don't need index
        num_motion_classes = length(results);
        
        for k=1:num_motion_classes
            category        = results(k).category;
            disp(category);

%             if ~strcmpi(category, 'walkRightCircle4StepsLstart')
%                 continue
%             end
            
            if ~isempty(results(k).hits)
                [precision, recall, n_relevant] = precision_recall2(category, results(k).hits, false, DB_info, true);
                
                
                num_rel_retrieved = round(precision .* [1:length(precision)]);
                %             idxFoundAll=find(num_rel_retrieved >= n_relevant);
                
                idxRel = [num_rel_retrieved(1)==1 diff(num_rel_retrieved)];
                L = min(length(idxRel), rankingVectorLength);
                %             if ~isempty(idxFoundAll)
                %                 L = min(L, idxFoundAll(1));
                %             end
                ranking = dot(idxRel(1:L), rankingVector(1:L)) / sum(rankingVector(1:L));
                
                r(k, j) = ranking;
            else
                r(k, j) = 0;
            end
        end
        
    end
    save(fullfile(fullPath, 'Cache', 'comparisonRankingResults'), 'r');
else
    load(fullfile(fullPath, 'Cache', 'comparisonRankingResults'));
end
