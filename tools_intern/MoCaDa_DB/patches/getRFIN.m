function RFIN = getRFIN( mot )

range = [1:min(50, mot.nframes)];

RFRM = [strmatch('RFRM', mot.nameMap(:,1), 'exact') strmatch('rfrm', mot.nameMap(:,1), 'exact')];
RWRA = [strmatch('RWRA', mot.nameMap(:,1), 'exact') strmatch('rwra', mot.nameMap(:,1), 'exact')];
RWRB = [strmatch('RWRB', mot.nameMap(:,1), 'exact') strmatch('rwrb', mot.nameMap(:,1), 'exact')];

if isempty(RFRM) || isempty(RWRA) || isempty(RWRB)
    error('On of the markers RFRM, RWRA and RWRB could not be found in the nameMap.');
    return;
end

% try find the trajectory of RFIN
goal = 0.5*mot.jointTrajectories{RWRA} + 0.5*mot.jointTrajectories{RWRB};
goal = 1.2*goal - 0.2*mot.jointTrajectories{RFRM};

for i=1:length(mot.jointTrajectories)
    diff = mot.jointTrajectories{i}(:,range) - goal(:,range);
    len(i) = sum(dot(diff, diff));
end

[minElement, RFIN] = min(len);
