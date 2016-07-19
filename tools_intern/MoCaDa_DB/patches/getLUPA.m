function LUPA = getLUPA( mot )

range = [1:min(50, mot.nframes)];

LSHO = [strmatch('LSHO', mot.nameMap(:,1), 'exact') strmatch('lsho', mot.nameMap(:,1), 'exact')];
LELB = [strmatch('LELB', mot.nameMap(:,1), 'exact') strmatch('lelb', mot.nameMap(:,1), 'exact')];

if isempty(LSHO) || isempty(LELB)
    error('The markers LSHO and/or LELB could not be found in the nameMap.');
    return;
end

% find the trajectory that is between LSHO and LELB
goal = 0.6*mot.jointTrajectories{LSHO} + 0.4*mot.jointTrajectories{LELB};

for i=1:length(mot.jointTrajectories)
    diff = mot.jointTrajectories{i}(:,range) - goal(:,range);
    len(i) = sum(dot(diff, diff));
end

[minElement, LUPA] = min(len);