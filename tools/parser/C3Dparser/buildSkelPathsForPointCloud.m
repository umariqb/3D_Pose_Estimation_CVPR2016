function paths = buildSkelPathsForPointCloud(skel)

for i = 1:skel.njoints
    paths{i,1} = [i;i];
end