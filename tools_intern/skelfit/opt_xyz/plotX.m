function plotX( X )

figure;
plot3(X(3*[1:41]-2), X(3*[1:41]-1), X(3*[1:41]-0), 'ro:');
cameratoolbar('Show');
cameratoolbar('SetCoordSys','y');
axis equal;