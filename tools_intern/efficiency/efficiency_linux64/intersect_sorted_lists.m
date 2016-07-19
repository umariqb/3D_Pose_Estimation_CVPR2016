function list_out = intersect_sorted_lists(list1,list2)

pos1 = 1;
pos2 = 1;
pos_out = 1;
num1 = length(list1);
num2 = length(list2);

list_out = zeros(min(num1,num2),1);
while ((pos1 <= num1) && (pos2 <= num2))
    if (list1(pos1) < list2(pos2))
        pos1 = pos1 + 1;
    elseif (list1(pos1) > list2(pos2))
        pos2 = pos2 + 1;
    else %(list1(pos1) == list2(pos2))
        list_out(pos_out) = list1(pos1);
        pos_out = pos_out + 1;
        pos1 = pos1 + 1;
        pos2 = pos2 + 1;
    end
end

list_out = list_out(1:pos_out-1);
