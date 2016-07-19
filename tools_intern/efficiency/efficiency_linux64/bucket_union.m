function list_out = bucket_union(c)
c_len = length(c);
c_min = inf;
c_max = -inf;
for k=1:c_len
    x = min(c{k});
    if (x < c_min)
        c_min = x;
    end
    x = max(c{k});
    if (x > c_max)
        c_max = x;
    end
end

a = zeros(1,c_max-c_min+1);
for k=1:c_len
    a(c{k}-c_min+1) = 1;
end

list_out = find(a>0)+c_min-1;
