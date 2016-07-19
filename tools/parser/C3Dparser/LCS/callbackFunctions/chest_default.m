function trajectories = chest_default( mot )

viconNames = {'STRN', 'T10', 'RFWT', 'LFWT', 'LBWT', 'RBWT', 'C7', 'T10'};

for i = 1:length(viconNames)
    idx(i) = strmatch(viconNames(i), mot.nameMap(:,1));
end
    
trajectories = 0.1 * mot.jointTrajectories{idx(1)} + 0.1 * mot.jointTrajectories{idx(2)} + 0.1 * mot.jointTrajectories{idx(3)}  ...
             + 0.1 * mot.jointTrajectories{idx(4)} + 0.05 * mot.jointTrajectories{idx(5)} + 0.05 *mot.jointTrajectories{idx(6)} ...
             + 0.25 * mot.jointTrajectories{idx(7)} + 0.25 * mot.jointTrajectories{idx(8)};
