function trajectories = rclavicle_default( mot )

viconNames = {'C7', 'STRN', 'T10'};

for i = 1:length(viconNames)
    idx(i) = strmatch(viconNames(i), mot.nameMap(:,1));
end
    
trajectories = 0.7 * mot.jointTrajectories{idx(1)} + 0.15 * mot.jointTrajectories{idx(2)} + 0.15 * mot.jointTrajectories{idx(3)};
