function hits = hits_DTW_postprocess(hits,DB,varargin)

eliminate_bad_matches = false;
if (nargin>3)
    eliminate_bad_matches = varargin{1};
end

ff = [hits.frame_first_matched_all];
[h,S] = sort(ff); % S is the sequence in which the hits have to be processed (sorted by first matching frame)
   
nhits = length(hits);
files_name = DB.files_name;
files_num = length(files_name);
files_frame_start = DB.files_frame_start;
files_frame_end = DB.files_frame_end;

bad_matches = [];
j = 1; % index into files_frame_start
for k=1:nhits
    while ((j <= files_num) && (hits(S(k)).frame_first_matched_all > files_frame_end(j)))
        j = j+1;
    end
    
    if (hits(S(k)).frame_last_matched_all <= files_frame_end(j)) 
        hits(S(k)).file_id = j;
        hits(S(k)).file_name = files_name{j};
        hits(S(k)).frame_first_matched = hits(S(k)).frame_first_matched_all - files_frame_start(j) + 1;
        hits(S(k)).frame_last_matched = hits(S(k)).frame_last_matched_all - files_frame_start(j) + 1;
        hits(S(k)).frame_length = hits(S(k)).frame_last_matched - hits(S(k)).frame_first_matched + 1;
        [info,OK] = filename2info_HDM_training(hits(S(k)).file_name);
        hits(S(k)).info = info;
    else % treat hits that reach over file boundaries
        bad_matches = [bad_matches S(k)];
        num_frames_this_file = files_frame_end(j) - hits(S(k)).frame_first_matched_all + 1;
        if (j<files_num)
            num_frames_next_file = hits(S(k)).frame_last_matched_all - files_frame_start(j+1) + 1;
        else
            num_frames_next_file = hits(S(k)).frame_last_matched_all - files_frame_end(j);
        end
        if (num_frames_next_file<num_frames_this_file)
            hits(S(k)).file_id = j;
            hits(S(k)).frame_first_matched = hits(S(k)).frame_first_matched_all - files_frame_start(j) + 1;
            hits(S(k)).frame_last_matched = files_frame_end(j) - files_frame_start(j) + 1;
        else
            hits(S(k)).file_id = j+1;
            hits(S(k)).frame_first_matched = 1;
            hits(S(k)).frame_last_matched = min(num_frames_next_file, files_frame_end(j+1) - files_frame_start(j+1) + 1);
        end
        hits(S(k)).file_name = files_name{hits(S(k)).file_id};
        hits(S(k)).frame_length = hits(S(k)).frame_last_matched - hits(S(k)).frame_first_matched + 1;
        [info,OK] = filename2info_HDM_training(hits(S(k)).file_name);
        hits(S(k)).info = info;
    end
end

if (eliminate_bad_matches)
    hits = hits(setdiff([1:nhits],bad_matches));
end