function [d,theta,x0,z0,Q] = pointCloudDist_modified(P,Q,varargin)

if size(P)~=size(Q)
    error('input error');
end

dataRep='pos';
if nargin==3
    dataRep=lower(varargin{1});
end

K = size(P,2);

xP = P(1,:);
zP = P(3,:);
xQ = Q(1,:);
zQ = Q(3,:);

xPc=mean(xP);
zPc=mean(zP);
xQc=mean(xQ);
zQc=mean(zQ);
N = dot(xP/K,zQ) - dot(xQ/K,zP) - (xPc*zQc - zPc*xQc);
D = dot(xP/K,xQ) + dot(zQ/K,zP) - (xPc*xQc + zPc*zQc);

theta = atan2(N,D);

x0 = xPc - xQc*cos(theta) - zQc*sin(theta);
z0 = zPc + xQc*sin(theta) - zQc*cos(theta);

% p=sqrt(sum(P.*P));
% q=sqrt(sum(Q.*Q));
% P=P./repmat(p,3,1);
% Q=Q./repmat(q,3,1);
% 
% d = (1-dot(P,Q))/2;
% 
% d = (1/K)*norm(P - (rotmatrix(theta,'y')*Q +
% repmat([x0;0;z0],1,K)),'fro');
% 
% d = (1/K)*norm(P - (rotmatrix(theta,'y')*Q),'fro');
% Q = rotmatrix(theta,'y')*Q;
% v = sqrt(sum(P.^2));
% w = sqrt(sum(Q.^2));
% 
% d = 1/2*((abs(v-w)./(v+w)) + 1/2*(1-dot(P,Q)/(v.*w)))*100;

% Q       = rotmatrix(theta,'y')*Q;
% p       = normOfColumns(P);
% q       = normOfColumns(Q);
% alpha   = 0.8;
% beta    = 1-alpha;
% d       = real(acos(dot(P,Q)./(p.*q)));

% d1 = P-Q;

if strcmpi(dataRep,'acc')||strcmpi(dataRep,'vel')
    Q = rotmatrix(theta,'y')*Q;
    d = P-Q;
else
    Q = rotmatrix(theta,'y')*Q + repmat([x0;0;z0],1,K);
    d = P-Q;
end