function [A, t, residuum] = getTransformation( markerCoords1, markerCoords2 )

% for i=1:length(markers)
%     markerIdx = trajectoryID(mot, markers{i});
%     markerCoords1(:, i) = mot.jointTrajectories{markerIdx}(:,frame1);
%     markerCoords2(:, i) = mot.jointTrajectories{markerIdx}(:,frame2);
% end

a1 = markerCoords1(:,1) - markerCoords1(:,2);
b1 = markerCoords1(:,1) - markerCoords1(:,3);
a2 = markerCoords2(:,1) - markerCoords2(:,2);
b2 = markerCoords2(:,1) - markerCoords2(:,3);

rotAxis = cross( a1 - a2, b1 - b2 );

if rotAxis == [0; 0; 0]
    error('Choose different points!');
end

% normalize
rotAxis = rotAxis / norm(rotAxis);

% determine ON-base for plane given by rotAxis
v = cross( rotAxis, rotAxis + [1; 0; 0] );
w = cross( rotAxis, v );

v = v / norm(v);
w = w / norm(w);

% projet a1 and a2 into plane
a1proj = dot(a1, v)*v + dot(a1, w)*w;
a2proj = dot(a2, v)*v + dot(a2, w)*w;

rotAngle = acos( dot(a1proj, a2proj) / norm(a1proj) / norm(a2proj) );

A = buildRotMatrix( rotAxis, rotAngle );

t = mean(markerCoords2 - A*markerCoords1, 2);
residuum = A*markerCoords1 + [t t t] - markerCoords2;
