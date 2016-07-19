function RUPA = getRUPA( mot )

range = [1:min(50, mot.nframes)];

RSHO = [strmatch('RSHO', mot.nameMap(:,1), 'exact') strmatch('rsho', mot.nameMap(:,1), 'exact')];
RELB = [strmatch('RELB', mot.nameMap(:,1), 'exact') strmatch('relb', mot.nameMap(:,1), 'exact')];

if isempty(RSHO) || isempty(RELB)
    error('The markers RSHO and/or RELB could not be found in the nameMap.');
    return;
end

% find the trajectory that is between RSHO and RELB
goal = 0.5*mot.jointTrajectories{RSHO} + 0.5*mot.jointTrajectories{RELB};

for i=1:length(mot.jointTrajectories)
    diff = mot.jointTrajectories{i}(:,range) - goal(:,range);
    len(i) = sum(dot(diff, diff));
end

[minElement, RUPA] = min(len);