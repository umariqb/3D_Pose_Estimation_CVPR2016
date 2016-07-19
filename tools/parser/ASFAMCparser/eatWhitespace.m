function l_out = eatWhitespace(l_in)
% fast forward in file, skipping whitespace and #-comments
n = 1; % begin pointer
m = length(l_in); % end pointer
for i = 1:length(l_in)
    c = double(l_in(i));
    if (c == 9) | (c == 10) | (c == 13) | (c == 32) % TAB, CR, LF, SPC
        n = n+1;
    elseif (c=='#') % ASF comment
        m = i-1;
    else
        break;
    end
end
l_out = l_in(n:m);
