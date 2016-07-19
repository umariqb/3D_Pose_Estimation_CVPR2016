function findDuplicateTrajectories( mot, delta )

if nargin < 2
    delta = 100;
end

for i=1:length(mot.jointTrajectories)-1
    for j=(i+1):length(mot.jointTrajectories)
        diff = sum(sum(abs(mot.jointTrajectories{i}-mot.jointTrajectories{j})));
        if diff < delta
            disp(['Trajectories ' num2str(i) ' (' mot.nameMap{i,1} ') and ' num2str(j) ' (' mot.nameMap{j,1} ') are similar (total difference is ' num2str(diff) ').']);
        end
    end
end
