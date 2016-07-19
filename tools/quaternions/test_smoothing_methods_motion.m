%clear all;
close all;

[skel,mot] = readMocapD(130); %130
range = [550:1095-46];
mot = cropMot(mot,range);
N = mot.nframes;

%n = 1*mot.samplingRate; if (~mod(n,2)) n=n+1; end % filter length, must be odd
n = 13;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%w = 1/n*ones(1,n);
w = ones(1,n); w((n-1)/2) = 1;
%w = FIR1(n-1,0.01);
w = w/sum(w);

motR4 = filterMot(skel,mot,w,'R4');
motS3 = filterMot(skel,mot,w,'S3');
motSphericalAverage = filterMot(skel,mot,w,'sphericalAverage');

v = feature_velPoint(mot,'ltoes','',0) * 2.54/(0.45*0.45);
vFR3 = feature_velPoint(mot,'ltoes','',100) * 2.54/(0.45*0.45);
vFR4 = feature_velPoint(motR4,'ltoes','',0) * 2.54/(0.45*0.45);
vFS3 = feature_velPoint(motS3,'ltoes','',0) * 2.54/(0.45*0.45);
vFSphericalAverage = feature_velPoint(motSphericalAverage,'ltoes','',0) * 2.54/(0.45*0.45);

figure;
plot(v,'k'); hold on;
plot(vFR3,'r');
plot(vFR4,'g');
plot(vFS3,'b');
plot(vFSphericalAverage,'c');
set(gca,'xlim',[100 200],'ylim',[0 1250],'yticklabel',[],'xticklabel',[]);
set(gca,'box','off','yticklabel',[],'xticklabel',[]);

printPaperPosition = [1   10   20  6]; %[left, bottom, width, height]
set(gcf,'PaperPosition',printPaperPosition); 
printName = '..\figures\print\fig_ltoes_velocity_quatfilter_130.eps';
print('-depsc2',printName);




% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [Q_filterSphericalAverageA1,max_it,t_filterSphericalAverageA1] = filterSphericalAverageA1(w,P,1,'sym');
% %max_it
% 
% subplot(4,1,3);
% plot(1:length(Q_filterSphericalAverageA1),Q_filterSphericalAverageA1);
% axis([1,length(Q_filterSphericalAverageA1),-1.1,1.1]);
% title(['Q\_filterSphericalAverageA1: t=' num2str(t_filterSphericalAverageA1) ', max\_it=' num2str(max_it)]);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %a = (1/n)*ones(1,n);
% % lambda = 1;
% % a = 1/24*[-lambda 4*lambda 24-6*lambda 4*lambda -lambda];
% a = FIR1(n-1,0.01);
% a = a/sum(a);
% b = orientationFilter(a);
% [Q_filterS3,t_filterS3] = filterS3(b,P,'sym');
% 
% subplot(4,1,4);
% plot([1:N],Q_filterS3);
% axis([1,N,-1.1,1.1]);
% title(['Q\_filterS3: t=' num2str(t_filterS3)]);
% 
% % figure;
% % subplot(2,1,1);
% % plot([1:N],P);
% % axis([1,N,-1.1,1.1]);
% % subplot(2,1,2);
% % plot([1:N],Q_filterS3);
% % axis([1,N,-1.1,1.1]);
% % title(['Q\_filterS3: t=' num2str(t_filterS3)]);
% 
% 
% % 
% % q = sphericalAverageA1(P,w);
% % 
% v = [1;1;1;1];
% Pproj = proj2hyperplane(v,0,P);
% Q_filterBruteForce_proj = proj2hyperplane(v,0,Q_filterBruteForce);
% Q_filterSphericalAverageA1_proj = proj2hyperplane(v,0,Q_filterSphericalAverageA1);
% Q_filterS3_proj = proj2hyperplane(v,0,Q_filterS3);
% 
% figure; set(gcf,'renderer','opengl'); hold on;
% plot3(Pproj(1,:),Pproj(2,:),Pproj(3,:),'.');
% plot3(Q_filterBruteForce_proj(1,:),Q_filterBruteForce_proj(2,:),Q_filterBruteForce_proj(3,:),'r.');
% plot3(Q_filterSphericalAverageA1_proj(1,:),Q_filterSphericalAverageA1_proj(2,:),Q_filterSphericalAverageA1_proj(3,:),'g.');
% plot3(Q_filterS3_proj(1,:),Q_filterS3_proj(2,:),Q_filterS3_proj(3,:),'k.');
% axis equal;