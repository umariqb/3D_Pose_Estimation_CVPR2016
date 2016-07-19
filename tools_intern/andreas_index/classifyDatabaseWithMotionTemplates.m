% FUNCTION classifyDatabaseWithMotionTemplates searches the Motion Database
% DB_name with the Feature set defined in feature_set for the motion
% classes defined in motionClasses. It returns the positions in the
% database where each motion class occurs.
% INPUT:
%   DB_name:        string: The name of the database that has previosly been calculated
%                   with DB_index_precompute as a DB_concat_ file
%   feature_set:    string: The name of the feature set that has been used to
%                   extract the features for the DB_concat_ file.
%   motionClasses:  A cell array containing strings. The strings are the
%                   motion classes that this function searches for in the
%                   DB_concat_ file.
%   indexbased:     boolean value. If true, than the occurences of the 
%                   motion classes are determined on a database that has
%                   previously been cut down by an indexing method.
%   maxHits:        integer: don't return more than maxHits hits.
%   intendedTakeIndices:  This is a vector containing the indices of all
%                         files inside DB_name in which this function
%                         should search for hits. Leave this argument out
%                         of set it to [] if you want the whole DB_name 
%                         to be searched.
%   visualize:      Set it to one if you want the database and results to be
%                   visualized. Leave out or set to zero if no
%                   visualization should be done.
%   
% OUTPUT:
%   A cell array POSITIONS of dimension 
%   size(POSITIONS)=[length(motionClasses),1].
%   Each entry in POSITIONS is a vector v using the following contract:
%   v_n = POSITIONS(n,1) = [start1 end1 start2 end2 start3 end3 ... ]
%   The entries in v_n are the start- end end-frames of each occurence
%   of motionClasses{n} in the Database.

function classPositions=classifyDatabaseWithMotionTemplates(DB_name, feature_set, motionClasses, indexbased, maxHits, intendedTakeIndices, visualize)

global VARS_GLOBAL;
% pre-allocate the cell array that will be returned
classPositions=cell(length(motionClasses), 1);

%define constants
basedir_templates = fullfile('HDM05_EG08_cut_amc_training','_templates','');
downsampling_fac = 4;
sampling_rate_string = num2str(120/downsampling_fac);
settings = ['5_0_' sampling_rate_string];   %settings of the dtw-template
feature_set_ranges = get_feature_set_ranges(feature_set);

if nargin < 7
    visualize = false;
end

% load the Database in which this function will search for the
% motionClasses
if (indexbased)
    [DB_concat,indexArray] = DB_index_load(DB_name,feature_set,downsampling_fac);
else
    DB_concat = DB_index_load(DB_name,feature_set,downsampling_fac); % don't need index
end


% search the database for every motion class
for k=1:length(motionClasses)

    category = motionClasses{k};     

    categoryName = concatStringsInCell(category);
    
    if indexbased
        %load the keyframes
        [motionTemplateKeyframes, motionTemplateKeyframePositions, motionTemplateKeyframesIndex, motionTemplateKeyframeDistances, stiffness, templateLength] = manualKeyframes(categoryName);
        extendLeft = 3*(motionTemplateKeyframePositions(1));
        extendRight = 3*(templateLength - motionTemplateKeyframePositions(end) + 1);

        %cut down DB_concat using the keyframes
        %first find segments that fit to the keyframes
        if (visualize)
            [segments,framesTotalNum] = keyframeSearch(motionTemplateKeyframes,...
                motionTemplateKeyframesIndex,...
                diff(motionTemplateKeyframePositions),...
                stiffness,...
                indexArray, ...
                extendLeft, ...
                extendRight,...
                DB_concat);
        else
            [segments,framesTotalNum] = keyframeSearchEfficient(motionTemplateKeyframes,...
                motionTemplateKeyframesIndex,...
                diff(motionTemplateKeyframePositions),...
                stiffness,...
                indexArray, ...
                extendLeft, ...
                extendRight);
        end;
                                                    
         %then cut down the database
         [DB_cut,segments_cut] = featuresCut(DB_concat,segments,indexArray,framesTotalNum,2);
    end
        
    %%%% load and threshold dtw-motion template
    [motionTemplateReal,motionTemplateWeights] = motionTemplateLoadMatfile(basedir_templates,categoryName,feature_set,settings);
    if (isempty(motionTemplateReal))
        error(['Motion Template for category ' category ' could not be found.']);
    end
    param.thresh_lo = 0.1;
    param.thresh_hi = 1-param.thresh_lo;
    param.visBool = 0;
    param.visReal = 0;
    param.visBoolRanges = false;
    param.visRealRanges = false;
    param.feature_set_ranges = feature_set_ranges;
    param.feature_set = feature_set;
    param.flag = 0;
    [motionTemplate,weights] = motionTemplateBool(motionTemplateReal,motionTemplateWeights,param);
    
    
    %% compute matches with the motion template
    parameter.visCost      = false;
    parameter.match_numMax = 500;
    parameter.match_thresh = 0.1;
    parameter.match_endExclusionForward = 0.1;
    parameter.match_endExclusionBackward = 0.5;
    parameter.match_startExclusionForward = 0.5;
    parameter.match_startExclusionBackward = 0.1;
    parameter.expandV = 1;    
    if indexbased
        [hits,C,D,delta] = motionTemplateDTWRetrievalWeighted(...
                              motionTemplate,weights,DB_cut.features,...
                              ones(1,size(DB_cut.features,2)),...
                              parameter,...
                              [1 1 2],[1 2 1],[1 1 2]); 
                          
        %post process hits
        [hits_cut,hits] = hits_DTW_postprocessSegments(hits,DB_cut,segments_cut,DB_concat,segments);
    else
        [hits,C,D,delta] = motionTemplateDTWRetrievalWeighted(...
                              motionTemplate,weights,DB_concat.features,...
                                ones(1,size(DB_concat.features,2)),...
                                parameter,...
                                [1 1 2],[1 2 1],[1 1 2]);
        %post process hits
        hits = hits_DTW_postprocess(hits,DB_concat);
    end
    hits_num=(length(hits));
    
    % now delete all hits that are outside of the intended takes
    if nargin > 5 && ~isempty(intendedTakeIndices)
        hitsIntended = zeros(1, hits_num);
        hitsIntendedCounter = 0;
        for h = 1:length(hits)
            if ~isempty(find(hits(h).file_id == intendedTakeIndices, 1))
                hitsIntendedCounter =         hitsIntendedCounter +1;
                hitsIntended(hitsIntendedCounter) = h;
            end
        end
        hitsIntended = hitsIntended(1:hitsIntendedCounter);                          
        if (indexbased)
            hits_cut = hits_cut(hitsIntended);               
        end
        hits = hits(hitsIntended);
    end

    if (visualize)
        showHitsClickableRankingSegments(hits_cut,DB_cut,feature_set,feature_set_ranges,downsampling_fac);
    end

    hits_num = min(maxHits, length(hits));

    positions=zeros(1, 2*hits_num);
    for n=1:hits_num
        
        positions(2*(n-1)+1) = hits(n).frame_first_matched_all;
        positions(2*n) = hits(n).frame_last_matched_all;
    end
    %classPositions{k} = positions;
    classPositions{k} = cell(hits_num,3);    
    for n=1:hits_num
        classPositions{k}{n,1} = hits(n).file_name;
        classPositions{k}{n,2} = hits(n).frame_first_matched;
        classPositions{k}{n,3} = hits(n).frame_last_matched;
    end
        
end
    


    

