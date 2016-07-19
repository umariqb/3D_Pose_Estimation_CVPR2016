function LFRM = getLFRM( mot )

range = [1:min(50, mot.nframes)];

LELB = [strmatch('LELB', mot.nameMap(:,1), 'exact') strmatch('lelb', mot.nameMap(:,1), 'exact')];
LWRB = [strmatch('LWRB', mot.nameMap(:,1), 'exact') strmatch('lwrb', mot.nameMap(:,1), 'exact')];

if isempty(LELB) || isempty(LWRB)
    error('The markers LELB and/or LWRB could not be found in the nameMap.');
    return;
end

% find the trajectory that is between LFWT and LWRB
goal = 0.5*mot.jointTrajectories{LELB} + 0.5*mot.jointTrajectories{LWRB};

for i=1:length(mot.jointTrajectories)
    diff = mot.jointTrajectories{i}(:,range) - goal(:,range);
    len(i) = sum(dot(diff, diff));
end

[minElement, LFRM] = min(len);
