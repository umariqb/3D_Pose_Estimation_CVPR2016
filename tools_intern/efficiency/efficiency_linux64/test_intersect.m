list1 = [100:200];
list2 = [50:150 175:300];
tic;
for k=1:10000
    list_out1 = intersect_sorted_lists(list1,list2);
end
toc;

tic;
for k=1:10000
    list_out2 = intersect(list1,list2);
end
toc;