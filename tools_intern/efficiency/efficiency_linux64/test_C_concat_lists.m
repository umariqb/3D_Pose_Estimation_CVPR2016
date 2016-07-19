cell_len = 1000;
num_repeats = 20;
c=cell(1,cell_len);
rand('seed',0);

for k=1:cell_len
    entry_len = fix(500+(rand(1)-0.5)*1000);
%    entry_len = 100;
    c{k} = [1:10000:20000*entry_len];
end
    
% tic
% for i = 1:num_repeats
%     q1 = zeros(1,cell_len*entry_len);
%     pos1 = 0;
%     pos2 = 0;
%     for k=1:cell_len
%         pos1 = pos2 + 1;
%         pos2 = pos2 + length(c{k});
%         q1(pos1:pos2) = c{k};
%     end
% end
% q1 = q1(1:pos2);
% q1 = unique(q1);
% toc
% 
% tic
% for i = 1:num_repeats
%     q2 = c{1};
%     for k=2:cell_len
%         q2 = union(q2,c{k});
%     end
% end
% toc
% 
tic
for i = 1:num_repeats
    q3 = C_concat_lists(c);
    q3 = unique(q3);
end
toc

tic
for i = 1:num_repeats
    q4 = C_union_presorted(c);
end
toc

tic
for i = 1:num_repeats
    q5 = C_union_presorted_stlport(c);
end
toc

% tic
% for i = 1:num_repeats
%     q6 = bucket_union(c);
% end
% toc