function trajectories = headtop_default( mot )

viconNames = {'RFHD', 'LFHD', 'RBHD', 'LBHD'};

for i = 1:length(viconNames)
    idx(i) = strmatch(viconNames(i), mot.nameMap(:,1));
end
    
trajectories = 0.15 * mot.jointTrajectories{idx(1)} + 0.15 * mot.jointTrajectories{idx(2)}  + 0.35 * mot.jointTrajectories{idx(3)}  + 0.35 * mot.jointTrajectories{idx(4)};
