function idx = getSingleJntIdx(jname,allJoints,dim)

if(iscell(jname))
    iter = length(jname);
else
    iter = 1;
end

a = 1;
b = 1;
for n = 1:iter
    if(iscell(jname))
        tmp = find(strcmp(jname(n), allJoints(:)));
    else
        tmp = find(strcmp(jname, allJoints(:)));
    end
    if(~isempty(tmp))
        cJidx(n,1)  = tmp;
        id2 = (tmp - 1) * 2 + 1;
        id3 = (tmp - 1) * 3 + 1;
        in2 = 0;
        in3 = 0;
        for j = 1: 2                                                % number of 2d joints
            cJidx2(a,1) = id2 + in2;
            in2 = in2 + 1;
            a = a + 1;
        end
        for j = 1: 3                                                % number of 2d joints
            cJidx3(b,1) = id3 + in3;
            in3 = in3 + 1;
            b = b + 1;
        end
    end
end
switch dim
    case 1
        idx = cJidx;
    case 2
        idx = cJidx2;
    case 3
        idx = cJidx3;
end

end

