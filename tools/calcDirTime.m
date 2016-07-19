function [seconds]=calcDirTime()


framecount=0;

dirs=dir;

for i=3:length(dirs)
    files=dir('*.mat');
    for j=1:length(files)
        load([dirs(i).name '\' files(j).name])
        framecount=framecount+mot.nframes;
    end
end

seconds=framecount/120;