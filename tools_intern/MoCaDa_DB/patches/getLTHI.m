function LTHI = getLTHI( mot )

range = [1:min(50, mot.nframes)];

LFWT = [strmatch('LFWT', mot.nameMap(:,1), 'exact') strmatch('lfwt', mot.nameMap(:,1), 'exact')];
LKNE = [strmatch('LKNE', mot.nameMap(:,1), 'exact') strmatch('lkne', mot.nameMap(:,1), 'exact')];

if isempty(LFWT) || isempty(LKNE)
    error('The markers LFWT and/or LKNE could not be found in the nameMap.');
    return;
end

% find the trajectory that is between LFWT and LKNE
goal = 0.3*mot.jointTrajectories{LFWT} + 0.7*mot.jointTrajectories{LKNE};

for i=1:length(mot.jointTrajectories)
    diff = mot.jointTrajectories{i}(:,range) - goal(:,range);
    len(i) = sum(dot(diff, diff));
end

[minElement, LTHI] = min(len);
