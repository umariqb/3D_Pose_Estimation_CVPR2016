function trajectories = rankle_default( mot )

viconNames = {'RANK', 'RTOE', 'RMT5'};

for i = 1:length(viconNames)
    idx(i) = strmatch(viconNames(i), mot.nameMap(:,1));
end

% Approximation: ankle joint is located 0.3 foot-widths from surface
dist = mot.jointTrajectories{idx(2)} - mot.jointTrajectories{idx(3)};

trajectories = mot.jointTrajectories{idx(1)} + 0.3 * dist;
