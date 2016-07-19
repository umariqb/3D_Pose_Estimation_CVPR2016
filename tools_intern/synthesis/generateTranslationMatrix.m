function T = generateTranslationMatrix( t1, mot1, t2, mot2, w )
%Erzeigt eine Matrix, die den zwei Teilsequenzen aneinander rotieren
%und translatieren kann
%
%  t1   = Zeitpunkt der zu einem Frame in der ersten Sequenz korrespondiert
%  mot1 = Die erste Sequenz, an die die zweite Seqeunz angepasst werden
%  kann
%  t2   = Zeitpunkt der zu einem Frame in der zweiten Sequenz korrespondiert
%  mot2 = Die zweite Sequenz
%  w    = Gewichtsfunktion zu den Gelenken


[ theta, x, z ] = calcTetaX0Z0(t1, mot1, t2, mot2, w);

T = zeros(4);

%Rotationsteil der Matrix
Rot_y = [ cos(theta) 0 sin(theta); ...
             0      1     0    ; ...
         -sin(theta) 0 cos(theta) ];

% Translationsteil der Matrix inklusive Rotationsteil
T(1,:) = [ Rot_y(1,:) x ];
T(2,:) = [ Rot_y(2,:) 0 ];
T(3,:) = [ Rot_y(3,:) z ];
T(4,4) = 1;


function [ theta, x0, z0 ] = calcTetaX0Z0(t1, mot1, t2, mot2, w)
%Berechnet die werte teta, x0, z0 ; siehe dazu auch im Paper
%Die Bezeichnungen sind beibehalten worden
%
%  t1   = Zeitpunkt der zu einem Frame in der ersten Sequenz korrespondiert
%  mot1 = Die erste Sequenz, an die die zweite Seqeunz angepasst werden
%  kann
%  t2   = Zeitpunkt der zu einem Frame in der zweiten Sequenz korrespondiert
%  mot2 = Die zweite Sequenz
%  w    = Gewichtsfunktion zu den Gelenken

% initialisierung
x = zeros(mot1.njoints,1);
z = zeros(mot1.njoints,1);
x_strich = zeros(mot2.njoints,1);
z_strich = zeros(mot2.njoints,1);
for i=1:mot1.njoints
     x(i) = mot1.jointTrajectories{i,1}(1,t1);
     z(i) = mot1.jointTrajectories{i,1}(3,t1);
     x_strich(i) = mot2.jointTrajectories{i,1}(1,t2);
     z_strich(i) = mot2.jointTrajectories{i,1}(3,t2);
end;

% Die erste Summe im Zähler von Theta
sum1 = sum( w .* ( x(:) .* z_strich(:) - x_strich(:) .* z(:) ) );
% Die erste Summe im Nenner von Theta
sum2 = sum( w .* ( x(:) .* x_strich(:) - z(:) .* z_strich(:) ) );
% Summe über alle Gewichte
gewsum = sum(w);

x_quwer = sum( w.*x(:) );
z_quwer = sum( w.*z(:) );
x_strich_quwer = sum( w.*x_strich(:) );
z_strich_quwer = sum( w.*z_strich(:) );


theta = atan( (sum1 - 1/gewsum * (x_quwer*z_strich_quwer - x_strich_quwer*z_quwer))...
    / (sum2 - 1/gewsum * ( x_quwer*x_strich_quwer - z_quwer*z_strich_quwer ) ) );

x0 = 1 / gewsum * (x_quwer - x_strich_quwer * cos(theta) - z_strich_quwer * sin(theta));

z0 = 1 / gewsum * (z_quwer - x_strich_quwer * sin(theta) - z_strich_quwer * cos(theta));
