function trajectories = rfingers_default( mot )

viconNames = {'RFIN'};
idx = [];

for i = 1:length(viconNames)
    temp = strmatch(viconNames(i), mot.nameMap(:,1));
    if not(isempty(temp))
        idx(i) = temp;
    end
end

trajectories = 0;
idx = idx(find(idx));

for i = 1:length(idx)
    trajectories = trajectories + 1/length(idx) * mot.jointTrajectories{idx(i)};
end

if isempty(idx)
    viconNames = {'LFIN', 'RWRA', 'RWRB', 'LWRA'};
    idx = [];
    
    for i = 1:length(viconNames)
        temp = strmatch(viconNames(i), mot.nameMap(:,1));
        if not(isempty(temp))
            idx(i) = temp;
        end
    end
    
    trajectories = 0.5*(mot.jointTrajectories{idx(2)} + mot.jointTrajectories{idx(3)}) + mot.jointTrajectories{idx(1)} - mot.jointTrajectories{idx(4)};
end
