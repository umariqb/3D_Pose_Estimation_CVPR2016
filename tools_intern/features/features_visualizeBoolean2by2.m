function features_visualizeBoolean2by2(nframes,x11,x12,x21,x22)
nfeatures = 3;
figure;
subplot(nfeatures,3,1);
y11 = zeros(nframes,1);
y11(x11) = 1;
plot(y11);
axis([1 nframes 0 1.1]);

subplot(nfeatures,3,2);
y12 = zeros(nframes,1);
y12(x12) = 1;
plot(y12);
axis([1 nframes 0 1.1]);

subplot(nfeatures,3,3);
plot(y11.*y12);
axis([1 nframes 0 1.1]);

subplot(nfeatures,3,4);
y21 = zeros(nframes,1);
y21(x21) = 1;
plot(y21);
axis([1 nframes 0 1.1]);

subplot(nfeatures,3,5);
y22 = zeros(nframes,1);
y22(x22) = 1;
plot(y22);
axis([1 nframes 0 1.1]);

subplot(nfeatures,3,6);
plot(y21.*y22);
axis([1 nframes 0 1.1]);

subplot(nfeatures,3,7);
plot(y11.*y21);
axis([1 nframes 0 1.1]);

subplot(nfeatures,3,8);
plot(y12.*y22);
axis([1 nframes 0 1.1]);

subplot(nfeatures,3,9);
plot(y11.*y12.*y21.*y22);
axis([1 nframes 0 1.1]);
