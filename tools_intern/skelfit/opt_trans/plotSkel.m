function plotSkel( skel )

skel = [skel{:}];
figure;
plot3(skel(1,:),skel(2,:),skel(3,:),'o');