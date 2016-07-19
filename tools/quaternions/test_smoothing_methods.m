%clear all;
close all;

[skel,mot] = readMocapD(130);
body_part = 3;  % lhip

% [skel,mot] = readMocapD(147);
% body_part = 8;  % rhip

P = mot.rotationQuat{body_part};
%P = repmat([slerp(quatnormalize([1;0;0;1]),[0;-1;0;0],[0:0.01:1]) slerp([0;-1;0;0],quatnormalize([-1;0;0.01;-1]),[0:0.01:1])],1,2);

N = size(P,2);

%n = 0.5*mot.samplingRate; if (~mod(n,2)) n=n+1; end % filter length, must be odd
n = 25;

figure;
subplot(4,1,1);
plot([1:N],P);
axis([1,N,-1.1,1.1]);
title(['Original data, P']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%w = 1/n*ones(1,n);
%w = ones(1,n); w((n-1)/2) = 1;
w = FIR1(n-1,0.01);
w = w/sum(w);
[Q_filterBruteForce,t_filterBruteForce] = filterR4(w,P,1,'sym');

subplot(4,1,2);
plot(1:length(Q_filterBruteForce),Q_filterBruteForce);
axis([1,length(Q_filterBruteForce),-1.1,1.1]);
title(['Q\_filterBruteForce: t=' num2str(t_filterBruteForce)]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Q_filterSphericalAverageA1,max_it,t_filterSphericalAverageA1] = filterSphericalAverageA1(w,P,1,'sym');
%max_it

subplot(4,1,3);
plot(1:length(Q_filterSphericalAverageA1),Q_filterSphericalAverageA1);
axis([1,length(Q_filterSphericalAverageA1),-1.1,1.1]);
title(['Q\_filterSphericalAverageA1: t=' num2str(t_filterSphericalAverageA1) ', max\_it=' num2str(max_it)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%a = (1/n)*ones(1,n);
% lambda = 1;
% a = 1/24*[-lambda 4*lambda 24-6*lambda 4*lambda -lambda];
a = FIR1(n-1,0.01);
a = a/sum(a);
b = orientationFilter(a);
[Q_filterS3,t_filterS3] = filterS3(b,P,'sym');

subplot(4,1,4);
plot([1:N],Q_filterS3);
axis([1,N,-1.1,1.1]);
title(['Q\_filterS3: t=' num2str(t_filterS3)]);

% figure;
% subplot(2,1,1);
% plot([1:N],P);
% axis([1,N,-1.1,1.1]);
% subplot(2,1,2);
% plot([1:N],Q_filterS3);
% axis([1,N,-1.1,1.1]);
% title(['Q\_filterS3: t=' num2str(t_filterS3)]);


% 
% q = sphericalAverageA1(P,w);
% 
v = [1;1;1;1];
Pproj = proj2hyperplane(v,0,P);
Q_filterBruteForce_proj = proj2hyperplane(v,0,Q_filterBruteForce);
Q_filterSphericalAverageA1_proj = proj2hyperplane(v,0,Q_filterSphericalAverageA1);
Q_filterS3_proj = proj2hyperplane(v,0,Q_filterS3);

figure; set(gcf,'renderer','opengl'); hold on;
plot3(Pproj(1,:),Pproj(2,:),Pproj(3,:),'.');
plot3(Q_filterBruteForce_proj(1,:),Q_filterBruteForce_proj(2,:),Q_filterBruteForce_proj(3,:),'r.');
plot3(Q_filterSphericalAverageA1_proj(1,:),Q_filterSphericalAverageA1_proj(2,:),Q_filterSphericalAverageA1_proj(3,:),'g.');
plot3(Q_filterS3_proj(1,:),Q_filterS3_proj(2,:),Q_filterS3_proj(3,:),'k.');
axis equal;