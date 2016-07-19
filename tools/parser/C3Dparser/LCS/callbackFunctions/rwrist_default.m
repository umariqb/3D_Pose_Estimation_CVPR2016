function trajectories = rwrist_default( mot )

viconNames = {'RWRB', 'RWRA'};

for i = 1:length(viconNames)
    idx(i) = strmatch(viconNames(i), mot.nameMap(:,1));
end

trajectories = 0;
for i = 1:length(idx)
    trajectories = trajectories + 1/length(idx) * mot.jointTrajectories{idx(i)};
end

