function v = mocap2mat(amcfullpath)

[info,OK] = filename2info(amcfullpath);
if (~OK)
    return;
end

asffullpath = [info.amcpath info.skeletonSource '_' info.skeletonID '.asf'];
amcMATfullpath = [amcfullpath '.MAT'];

if (strcmpi(info.filetype,'BVH'))
    [skel,mot] = readMocap(amcfullpath);
else
    [skel,mot] = readMocap(asffullpath, amcfullpath);
end

save(amcMATfullpath, 'skel', 'mot');

v = mot.nframes;

