function CLAV = getCLAV( mot )

range = [1:min(50, mot.nframes)];

LSHO = [strmatch('LSHO', mot.nameMap(:,1), 'exact') strmatch('lsho', mot.nameMap(:,1), 'exact')];
RSHO = [strmatch('RSHO', mot.nameMap(:,1), 'exact') strmatch('rsho', mot.nameMap(:,1), 'exact')];
STRN = [strmatch('STRN', mot.nameMap(:,1), 'exact') strmatch('strn', mot.nameMap(:,1), 'exact')];
T10 = [strmatch('T10', mot.nameMap(:,1), 'exact') strmatch('t10', mot.nameMap(:,1), 'exact')];

if isempty(LSHO) || isempty(RSHO) || isempty(STRN) || isempty(T10)
    error('Some of the markers LSHO, RSHO, T10 and STRN could not be found in the nameMap.');
    return;
end

% determine trajectory that is closest to a possible CLAV-trajectory
% goal = (0.5*mot.jointTrajectories{LSHO} + 0.5*mot.jointTrajectories{RSHO}) - ...
%         0.1*cross( mot.jointTrajectories{LSHO} - mot.jointTrajectories{STRN}, mot.jointTrajectories{RSHO} - mot.jointTrajectories{STRN} );

goal = 0.5*mot.jointTrajectories{LSHO} + 0.5*mot.jointTrajectories{RSHO} + 0.2*(mot.jointTrajectories{STRN} - mot.jointTrajectories{T10});

for i=1:length(mot.jointTrajectories)
    diff = mot.jointTrajectories{i}(range) - goal(range);
    len(i) = sum(dot(diff, diff));
end


[minElement, CLAV] = min(len);
