function LFWT = getLFWT( mot )

range = [1:min(50, mot.nframes)];

RFWT = [strmatch('RFWT', mot.nameMap(:,1), 'exact') strmatch('lbhd', mot.nameMap(:,1), 'exact')];
RBWT = [strmatch('RBWT', mot.nameMap(:,1), 'exact') strmatch('rbhd', mot.nameMap(:,1), 'exact')];
LBWT = [strmatch('LBWT', mot.nameMap(:,1), 'exact') strmatch('rfhd', mot.nameMap(:,1), 'exact')];

if isempty(RFWT) || isempty(RBWT) || isempty(LBWT)
    error('Some of the markers RFWT, RBWT and LBWT could not be found in the nameMap.');
    return;
end

% determine trajectory that is closest to a possible LFHD-trajectory
goal = mot.jointTrajectories{LBWT} + mot.jointTrajectories{RFWT} - mot.jointTrajectories{RBWT};

for i=1:length(mot.jointTrajectories)
    diff = mot.jointTrajectories{i}(:,range) - goal(:,range);
    len(i) = sum(dot(diff, diff));
end

[minElement, LFWT] = min(len);
