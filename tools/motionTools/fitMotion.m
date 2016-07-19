% FUNCTION fitMotion applays a translation and a rotation around y-axis to
% a given motion. The motion is moved with root position to the origin with
% the first frame. And rotated that the main direction goes along the
% x-Axis.
% INPUT:
%   skel:   struct: skeleton definition for the motion
%   mot:    struct: 

function [mot,angle,x0,z0]=fitMotion(skel,mot)

% Spatial correspondence -------------------------------------------
% translation into y-axis
x0=mot.rootTranslation(1,1);
z0=mot.rootTranslation(3,1);
mot.rootTranslation(1,:)=mot.rootTranslation(1,:)-x0;
mot.rootTranslation(3,:)=mot.rootTranslation(3,:)-z0;

if (sqrt(mot.rootTranslation(1,mot.nframes)^2+mot.rootTranslation(3,mot.nframes)^2)>10)
    u=[mot.rootTranslation(1,mot.nframes);mot.rootTranslation(3,mot.nframes)];
    v=[1;0];

    angle=acos((u'*v)/(sqrt(u'*u)));

    if u(2)<0
        angle=-angle;
    end
else
    m=quatrot([0;0;1],mot.rotationQuat{1}(:,1));
    u=[m(1);m(3)];
    v=[1;0];
    angle=acos((u'*v)/(sqrt(u'*u)));
    if u(2)<0
        angle=-angle;
    end
end

mot=rotateMotion(skel,mot,angle,'y');
