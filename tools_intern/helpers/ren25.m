function output = ren25( dirname )

oldpath = cd;

cd(dirname);
files = dir('*_120.avi');

for i=1:length(files)
    newName = files(i).name;
    newName = [newName(1:end-7) '25.avi'];
    dos(['ren ' files(i).name ' ' newName]);
end

cd(oldpath);
output = 0;