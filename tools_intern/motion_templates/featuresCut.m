function [f,segments] = featuresCut(DB,segments,index,num_frames_total,num_NaN_padding)

num_matches_total = size(segments,2);

f.files_frame_start = zeros(1,num_matches_total);
f.files_frame_end = zeros(1,num_matches_total);
f.files_frame_length = zeros(1,num_matches_total);
f.features = zeros(size(DB.features,1),num_frames_total+num_matches_total*num_NaN_padding);
DB_files_frame_start = DB.files_frame_start;
DB_features = DB.features;
pos1 = 1;
pos2 = 0;
k = 1;
counter = 1;
docs = zeros(1,num_matches_total);
while k<=num_matches_total
    doc = segments(1,k);
    docs(counter) = doc;
    f.files_frame_start(counter) = pos1;
    k1 = k;
    while k<=num_matches_total && segments(1,k) == doc
       file_start_DB = DB_files_frame_start(doc);
       pos2 = pos1 + segments(3,k)-segments(2,k);
       f.features(:,pos1:pos2) = DB_features(:,file_start_DB+segments(2,k)-1:file_start_DB+segments(3,k)-1);
       f.features(:,pos2+1:pos2+num_NaN_padding) = NaN;
       f.files_frame_end(counter) = pos2;
       segments(2,k) = pos1-f.files_frame_start(counter)+1;
       segments(3,k) = pos2-f.files_frame_start(counter)+1;
       pos1 = pos2 + num_NaN_padding + 1;
       k2 = k;
       k = k+1;
    end
    f.files_frame_length(counter) = f.files_frame_end(counter)-f.files_frame_start(counter)+1;
    segments(1,k1:k2) = counter;
    counter = counter+1;
end
f.files_frame_end = f.files_frame_end(1:counter-1);
f.files_frame_start = f.files_frame_start(1:counter-1);
f.files_frame_length = f.files_frame_length(1:counter-1);
docs = docs(1:counter-1);

f.files_name = DB.files_name(docs);
