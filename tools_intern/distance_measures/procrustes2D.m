function [theta,x0,z0,xPc,zPc,xQc,zQc] = procrustes2D(P,Q,varargin)
% [theta,x0,z0] = procrustes2D(P,Q,w)
% Finds optimal alignment parameters to align Q with P.

% w = ones(1,size(P,2));
%w = zeros(1,size(P,2));
%w(2:12) = 1;

xP = P(1,:);
zP = P(3,:);
xQ = Q(1,:);
zQ = Q(3,:);

if nargin==2
    w=1/size(P,2);
    xPc=mean(xP);
    zPc=mean(zP);
    xQc=mean(xQ);
    zQc=mean(zQ);
    N = dot(w*xP,zQ) - dot(w*xQ,zP) - (xPc*zQc - zPc*xQc);
    D = dot(w*xP,xQ) + dot(w*zQ,zP) - (xPc*xQc + zPc*zQc);
else
    w = varargin{1};
    w = w/sum(w);
    xPc = sum(w.*xP); 
    zPc = sum(w.*zP);
    xQc = sum(w.*xQ);
    zQc = sum(w.*zQ);
    N = w.*xP*zQ' - w.*xQ*zP' - (xPc*zQc - zPc*xQc);
    D = w.*xP*xQ' + w.*zQ*zP' - (xPc*xQc + zPc*zQc);
end

theta = atan2(N,D);

x0 = xPc - xQc*cos(theta) - zQc*sin(theta);
z0 = zPc + xQc*sin(theta) - zQc*cos(theta);