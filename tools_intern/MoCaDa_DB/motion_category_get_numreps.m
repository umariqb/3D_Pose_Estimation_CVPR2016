function [n,category_noreps] = motion_category_get_numreps(category)
% n is the number of repetitions of a motion, according to the Mocada naming scheme for the file category tag
% I is the index of the last character belonging to the name of the motion class within the string "category"

I = find(category>=48 & category<=57);

if (isempty(I))
    n = 1;
    I = length(category);
    category_noreps = category;
else
    if (length(I)==1)
        n = str2num(category(I));
        I = I-1;
        I2 = find(category(I+3:end)>=65 & category(I+3:end)<=90);
        if (isempty(I2))
            I2 = length(category);
        end
        category_noreps = category([1:I I2(1)+I+2:end]);
    else
%        warning('Too many numerals in category string. Setting n=1.');
        n = 1;
        I = length(category);
        category_noreps = category;
    end
end