function trajectories = lknee_default( mot )

viconNames = {'LKNE', 'LTOE', 'LMT5', 'LANK'};

for i = 1:length(viconNames)
    idx(i) = strmatch(viconNames(i), mot.nameMap(:,1));
end
    
distX = mot.jointTrajectories{idx(2)} - mot.jointTrajectories{idx(3)};
distY = mot.jointTrajectories{idx(3)} - mot.jointTrajectories{idx(4)};

trajectories = mot.jointTrajectories{idx(1)} + 0.6 * distX + 0.2 * distY;
