function trajectories = lhip_default( mot )

% REMARK: unfortunately the 'LTHI' marker is not available in all takes, 
% so we can not use it for estimation.

viconNames = {'LFWT', 'LBWT', 'RBWT'};

for i = 1:length(viconNames)
    idx(i) = strmatch(viconNames(i), mot.nameMap(:,1));
end

% compute vector orthogonal to ('LFWT', 'LBWT', 'RBWT') - plane
v1 = mot.jointTrajectories{idx(2)} - mot.jointTrajectories{idx(1)};
v2 = mot.jointTrajectories{idx(2)} - mot.jointTrajectories{idx(3)};
orth = cross(v1,v2);
normOrth = sqrt(dot(orth,orth));

% scale length to 'LFWT'-'LBWT' distance
orth = orth ./ [normOrth;normOrth;normOrth] * mean(sqrt(dot(v1,v1))); 

% estimate position
trajectories = 0.7 * mot.jointTrajectories{idx(1)} + 0.3 * mot.jointTrajectories{idx(2)} + 0.4 * orth;

