function [means, stds, maxdiffs] = analyseDir( directory, bones )
% [means, stds, maxdiffs] = analyse( directory, bones )
%
%       directory: full path to *.C3D files
%       bones    : bones to examine (e.g. {{'lsho', 'lelb'}, {'lsho', 'lupa'}}

if nargin < 1
    help analyseDir;
    return;
end

if nargin < 2
    bones = { {'lsho', 'lelb'}, {'lsho', 'lupa'}, {'lupa', 'lelb'}, {'lelb', 'lwrb'}, {'lelb', 'lfrm'}, {'lfwt', 'lkne'}, {'lkne', 'lank'}, {'clav', 'lsho'}};
end

oldDir = cd;

cd(directory)
path = cd; % needed later in case of relative paths
files = dir('*.c3d');

for i=1:length(files)
    filename = [path '\' files(i).name];
    disp(['processing file ' filename ' ...']);
    [skel,mot] = readMocapSmart(filename, false);
  
    for j = 1:length(bones)
	
        bone = bones{j};
        % determine joint numbers
        idx1 = strmatch(upper(bone{1}), upper({mot.nameMap{:,1}}), 'exact');
        idx2 = strmatch(upper(bone{2}), upper({mot.nameMap{:,1}}), 'exact');
	
        % error if not found in nameMap
        if isempty(idx1)
            error(['ERROR: Joint name "' bone{1} '" could not be found in mot.nameMap!']);
        end
        if isempty(idx2)
            error(['ERROR: Joint name "' bone{2} '" could not be found in mot.nameMap!']);
        end
    
        % do the calculations
        diff = mot.jointTrajectories{idx1} - mot.jointTrajectories{idx2};
    	diff = sqrt(dot(diff, diff));
        
        means(i,j) = mean(diff);
        stds(i,j) = std(diff);
        maxdiffs(i,j) = max(max(diff) - mean(diff), mean(diff) - min(diff));

    end
end

figure;
subplot(1,2,1), plot(stds);
title('standard deviation');
subplot(1,2,2), plot(maxdiffs);
title('maximum deviation');

cd(oldDir);
disp('done.');