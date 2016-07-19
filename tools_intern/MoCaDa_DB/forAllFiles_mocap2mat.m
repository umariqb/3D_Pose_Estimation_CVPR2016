function y = forAllFiles_mocap2mat(startdir)

y = [];
y = forAllFilesInDir(startdir, {'*.amc', '*.bvh'}, @mocap2mat, true, y);