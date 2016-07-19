function LFHD = getLFHD( mot )

range = [1:min(50, mot.nframes)];

LBHD = [strmatch('LBHD', mot.nameMap(:,1), 'exact') strmatch('lbhd', mot.nameMap(:,1), 'exact')];
RBHD = [strmatch('RBHD', mot.nameMap(:,1), 'exact') strmatch('rbhd', mot.nameMap(:,1), 'exact')];
RFHD = [strmatch('RFHD', mot.nameMap(:,1), 'exact') strmatch('rfhd', mot.nameMap(:,1), 'exact')];

if isempty(LBHD) || isempty(RBHD) || isempty(RFHD)
    error('Some of the markers LBHD, RBHD and RFHD could not be found in the nameMap.');
    return;
end

% determine trajectory that is closest to a possible LFHD-trajectory
goal = mot.jointTrajectories{LBHD} + mot.jointTrajectories{RFHD} - mot.jointTrajectories{RBHD};

for i=1:length(mot.jointTrajectories)
    diff = mot.jointTrajectories{i}(:,range) - goal(:,range);
    len(i) = sum(dot(diff, diff));
end

[minElement, LFHD] = min(len);
