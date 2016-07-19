function con = PrimConnector(head, tail, thickness)
% function:
%   Connector(head, tail, thickness)
% input:
%   head:      1x3 vector (position in world coordinates)
%   tail:      1x3 vector (position in world coordinates)
%   thickness: the thickness of the connector,
%              depending on the length
% output:
%   struct containing the vertices and faces of the connector
%   struct('vertices',vertices,'faces',faces)
% descrption:
%   the connector is a 3d object which connects the head
%   of a bone with the tail of a bone through a diamond like
%   object

% setup connector without rotations on pos [.0 .0 .0]
c = (tail - head);
length = sqrt(sum(c.^2));
lengthToMid = length * .25;

h = [.0 .0 .0];
v1 = [lengthToMid thickness .0];
v2 = [lengthToMid .0 thickness];
v3 = [lengthToMid -thickness .0];
v4 = [lengthToMid .0 -thickness];
t = [length .0 .0];

vertices = [h; v1; v2; v3; v4; t];
faces = [...
    [1 2 3]; [1 3 4]; [1 4 5]; [1 5 2];...
    [6 2 3]; [6 3 4]; [6 4 5]; [6 5 2]];

% rotation part
% rotation is done by quaternions
xaxis = [1 .0 .0];
cnorm = c / length;
alpha = acos(cnorm(1));

% cross product
rotAxis = [...
    xaxis(2)*cnorm(3) - xaxis(3)*cnorm(2) ...
    xaxis(3)*cnorm(1) - xaxis(1)*cnorm(3) ...
    xaxis(1)*cnorm(2) - xaxis(2)*cnorm(1)];

if(sqrt(sum(rotAxis.^2)) > 0)
    rotAxis = rotAxis / sqrt(sum(rotAxis.^2));
    q = [cos(alpha/2) rotAxis*sin(alpha/2)];
    q = quatnormalize(q');
    vertices = quatrot(vertices',q)';
end

% translation part
vertices  = translateVertices(vertices, head);

con = struct('vertices',vertices,'faces',faces);
end
