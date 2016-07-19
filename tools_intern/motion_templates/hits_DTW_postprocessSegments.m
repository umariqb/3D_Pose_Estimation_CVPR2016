function [hits_cut,hits] = hits_DTW_postprocessSegments(hits,DB_cut,segments_cut,DB,segments,varargin)

eliminate_bad_matches = false;
if (nargin>6)
    eliminate_bad_matches = varargin{1};
end

ff = [hits.frame_first_matched_all];
[h,S] = sort(ff); % S is the sequence in which the hits have to be processed (sorted by first matching frame)
   
nhits = length(hits);
files_name = DB_cut.files_name;
files_num = length(files_name);
files_frame_start = DB_cut.files_frame_start;
files_frame_end = DB_cut.files_frame_end;

hits_cut = hits;

segments_num = size(segments,2);

bad_matches = [];
j = 1; % index into files_frame_start
counter_seg = 1; % index into segments_cut
for k=1:nhits
    while ((j <= files_num) && (hits(S(k)).frame_first_matched_all > files_frame_end(j)))
        j = j+1;
    end
    
    while ((counter_seg < segments_num) && (j > segments_cut(1,counter_seg)))
        counter_seg = counter_seg+1;
    end
    while ((counter_seg < segments_num) && (hits(S(k)).frame_first_matched_all > segments_cut(3,counter_seg)+files_frame_start(j)-1))
        counter_seg = counter_seg+1;
    end
    
    if (hits(S(k)).frame_last_matched_all <= files_frame_end(j)) 
        file_id = segments(1,counter_seg);
        file_id_cut = j;
        
        hits_cut(S(k)).file_id = file_id_cut;
        hits_cut(S(k)).file_name = files_name{j};
        hits_cut(S(k)).frame_first_matched = hits_cut(S(k)).frame_first_matched_all - files_frame_start(j) - segments_cut(2,counter_seg) + 1 + segments(2,counter_seg);
        hits_cut(S(k)).frame_last_matched = hits_cut(S(k)).frame_last_matched_all - files_frame_start(j) - segments_cut(2,counter_seg) + 1 + segments(2,counter_seg);
        hits_cut(S(k)).frame_length = hits_cut(S(k)).frame_last_matched - hits_cut(S(k)).frame_first_matched + 1;
        [info,OK] = filename2info_HDM_training(hits_cut(S(k)).file_name);
        hits_cut(S(k)).info = info;

        hits(S(k)).file_id = file_id;
        hits(S(k)).file_name = convertfilenames(files_name{j});
        hits(S(k)).frame_first_matched = hits_cut(S(k)).frame_first_matched;
        hits(S(k)).frame_last_matched = hits_cut(S(k)).frame_last_matched;
        hits(S(k)).frame_first_matched_all = hits(S(k)).frame_first_matched + DB.files_frame_start(file_id) - 1;
        hits(S(k)).frame_last_matched_all = hits(S(k)).frame_last_matched + DB.files_frame_start(file_id) - 1;
        hits(S(k)).frame_length = hits(S(k)).frame_last_matched - hits(S(k)).frame_first_matched + 1;
        hits(S(k)).info = info;
    else % treat hits that reach over file boundaries
%         bad_matches = [bad_matches S(k)];
%         num_frames_this_file = files_frame_end(j) - hits(S(k)).frame_first_matched_all + 1;
%         if (j<files_num)
%             num_frames_next_file = hits(S(k)).frame_last_matched_all - files_frame_start(j+1) + 1;
%         else
%             num_frames_next_file = hits(S(k)).frame_last_matched_all - files_frame_end(j);
%         end
%         if (num_frames_next_file<num_frames_this_file)
%             hits(S(k)).file_id = j;
%             hits(S(k)).frame_first_matched = hits(S(k)).frame_first_matched_all - files_frame_start(j) + 1;
%             hits(S(k)).frame_last_matched = files_frame_end(j) - files_frame_start(j) + 1;
%         else
%             hits(S(k)).file_id = j+1;
%             hits(S(k)).frame_first_matched = 1;
%             hits(S(k)).frame_last_matched = min(num_frames_next_file, files_frame_end(j+1) - files_frame_start(j+1) + 1);
%         end
%         hits(S(k)).file_name = files_name{hits(S(k)).file_id};
%         hits(S(k)).frame_length = hits(S(k)).frame_last_matched - hits(S(k)).frame_first_matched + 1;
%         [info,OK] = filename2info_HDM_training(hits(S(k)).file_name);
%         hits(S(k)).info = info;
    end
end

if (eliminate_bad_matches)
    hits = hits(setdiff([1:nhits],bad_matches));
end