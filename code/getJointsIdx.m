function opts = getJointsIdx(opts)

if(isstruct(opts) && isfield(opts,'cJoints'))
    opts.cJidx  = nan(length(opts.cJoints),1);
    opts.cJidx2 = nan(2*length(opts.cJoints),1);
    opts.cJidx3 = nan(3*length(opts.cJoints),1);
    iter = length(opts.cJoints);
else
    disp('please specify cJoints and all jopints info ... ');
end
a = 1;
b = 1;
for k = 1:iter
    tmp = find(strcmp(opts.cJoints(k), opts.allJoints(:)));
    if(~isempty(tmp))
        opts.cJidx(k)  = tmp;
        id2 = (tmp - 1) * 2 + 1;
        id3 = (tmp - 1) * 3 + 1;
        in2 = 0;
        for j = 1: 2                                                 % number of 2d joints
            opts.cJidx2(a) = id2 + in2;
            in2 = in2 + 1;
            a = a + 1;
        end
        in3 = 0;
        for j = 1: 3                                                 % number of 2d joints
            opts.cJidx3(b) = id3 + in3;
            in3 = in3 + 1;
            b = b + 1;
        end
    end
end

end

