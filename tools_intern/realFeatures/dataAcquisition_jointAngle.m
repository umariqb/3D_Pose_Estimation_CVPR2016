function theData = dataAcquisition_jointAngle(theData, mot, featureSet, recursionLevel, b_verbose)
% theData = gmm_dataAcquisition_jointAngle(theData, mot, featureSet, recursionLevel, verbose);
%
% called by function "dataAcquisition", implements feature extraction for the
% joint angle feature
% 
% INPUT
%   theData .......... (matrix), containing the data, expanded and updated after each 
%                      recursion
%   mot .............. (struct) motion data (inherited)
%   featureSet ....... (struct), the feature set (inherited)
%   recursionLevel ... level of recursion
%   verbose .......... boolean, optional text output (inherited)
%
% OUTPUT
%   theData ...... (matrix, [ndata x dim]) containing the data
%

if b_verbose
    disp(['Level of recursion: ', num2str(recursionLevel)]);
end

inp01 = jointName2ID(mot, featureSet(recursionLevel,1),'traj');
inp02 = jointName2ID(mot, featureSet(recursionLevel,2),'traj');
inp03 = jointName2ID(mot, featureSet(recursionLevel,3),'traj');
inp04 = jointName2ID(mot, featureSet(recursionLevel,4),'traj');

%%%%%%%%%%%
%% Zusammenstellung der Daten
%%%%%%%%%%%
A = mot.jointTrajectories{inp01};
B1 = mot.jointTrajectories{inp02};
B2 = mot.jointTrajectories{inp03};
C = mot.jointTrajectories{inp04};

global VARS_GLOBAL;

if (B2==B1)
    % Bei gleichen "Mittelgelenken" kann man die beiden Segmente einfach
    % aneinandermatschen
    B = B1;
else 
    % ansonsten sollte man das eine Segment an das andere dranbasteln
    B = B1;
    C = B1 + C - B2;
end
clear B1 B2;

% danach die Richtungen (inkl. L‰ngen) der Segmente bestimmen
BA = A-B;
BC = C-B;

phi_rad = zeros(1,length(A));
phi_deg_out = zeros(1,length(A));

% und den von ihnen eingeschlossenen Winkel;
% der errechnete Winkel wird sich im Intervall [0, pi] bewegen.
l_BA = sqrt(dot(BA,BA));
l_BC = sqrt(dot(BC,BC));
% angle(ABC) = angle(BA, BC)
skp = dot(BA,BC);
phi_rad = skp./(l_BA.*l_BC);

% REALTEIL, da acos sonst schonmal komplex wird.
% Und zwar immer genau dann, wenn phi_rad \notin [-1, 1];
% aber ich denke, daﬂ dies "nur" ein Rundungsfehler ist.
% phi_deg_out = rad2deg(real(acos(phi_rad)));

phi_deg_out = real(acos(phi_rad));

% Zuweisung des Ergebnis'
%theData(:,recursionLevel) = phi_deg_out';
theData(recursionLevel,:) = phi_deg_out;


% wenn's mehr als ein Gelenk war, rekursiere
if (size(featureSet,1) == recursionLevel)
    return;
else
    theData = dataAcquisition_jointAngle(theData, mot, featureSet, recursionLevel+1, b_verbose);
end
%% ENDE Zusammenstellung der Daten

%end % of function feature_jointAngle
