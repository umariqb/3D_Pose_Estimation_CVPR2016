function l_out = eatWhitespace(l_in)
% fast forward in file, skipping whitespace
n = 1;
for i = 1:size(l_in,2)
    c = double(l_in(i));
    if (c == 9) | (c == 10) | (c == 13) | (c == 32) % TAB, CR, LF, SPC
        n = n+1;
    else
        break;
    end
end
l_out = l_in(n:size(l_in,2));
