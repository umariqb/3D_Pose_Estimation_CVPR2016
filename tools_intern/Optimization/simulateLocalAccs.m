function simAccs = simulateLocalAccs(skel,mot,joint,noise)

q = quatnormalize(C_euler2quat(rand(3,1)*2*pi));
% q = [1 0 0 0]';

mot = addAccToMot(mot);
figure
subplot(2,2,1);
plot(mot.jointAccelerations{joint}');
title('Global Acceleration');

mot = computeLocalSystems(skel,mot);
simAccs = C_quatrot(mot.jointAccelerations{joint}+repmat([0;9.81;0],1,mot.nframes),C_quatinv(mot.localSystems{joint}));
subplot(2,2,2);
plot(simAccs');
title('Local Acceleration (incl. gravity)');
simAccs = C_quatrot(simAccs,q);
subplot(2,2,3);
plot(simAccs');
title('Local Acc. randomly rotated');
simAccs = simAccs+(rand(size(simAccs))*2-1)*noise;
subplot(2,2,4);
plot(simAccs');
title('Local Acc. with noise');