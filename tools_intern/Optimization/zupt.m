% zero velocity updates
% input:
% a  - global accelerations (nSamples x 3), gravity removed
% t0 - start frame of motion (here velocity is said to be zero)
% T  - end frame of motion (here velocity is said to be zero)
% frameRate - frame rate 
% output:
% res.v  - velocity before correction
% res.vc - velocity after correction
% res.x  - position before correction
% res.xc - position after correction
%
% author: Jochen Tautges (tautges@cs.uni-bonn.de)

function res = zupt(a,t0,T,frameRate)

% a(:,1)=a(:,1)-mean(a([1:t0 T:end],1));
% a(:,2)=a(:,2)-mean(a([1:t0 T:end],2));
% a(:,3)=a(:,3)-mean(a([1:t0 T:end],3));

offsetX_left = mean(a(1:t0,1));
offsetY_left = mean(a(1:t0,2));
offsetZ_left = mean(a(1:t0,3));
offsetX_right = mean(a(T:end,1));
offsetY_right = mean(a(T:end,2));
offsetZ_right = mean(a(T:end,3));

offsetX = offsetX_left:(-offsetX_left+offsetX_right)/(T-t0):offsetX_right;
offsetY = offsetY_left:(-offsetY_left+offsetY_right)/(T-t0):offsetY_right;
offsetZ = offsetZ_left:(-offsetZ_left+offsetZ_right)/(T-t0):offsetZ_right;

res.a   = a(t0:T,:);

res.a(:,1)=res.a(:,1)-offsetX';
res.a(:,2)=res.a(:,2)-offsetY';
res.a(:,3)=res.a(:,3)-offsetZ';

T       = T-t0+1;
t0      = 1;

nSamples    = size(res.a,1);

res.v       = cumtrapz(res.a);
res.vc      = zeros(size(res.a));

for t = 1:nSamples
    res.vc(t,:) = res.v(t,:) + (res.v(t0,:)-res.v(T,:))*(t/T) - res.v(t0,:);
end

res.x   = cumtrapz(res.v);
res.xc  = zeros(size(res.a));

for t = 1:nSamples
    res.xc(t,:) = res.x(t,:) + (res.v(t0,:)-res.v(T,:))*(t^2)/(2*T) - res.v(t0,:)*t - res.x(t0,:);
end

res.v  = res.v / frameRate;
res.vc = res.vc / frameRate;
res.x  = res.x / frameRate^2;
res.xc = res.xc / frameRate^2;

% nSamples    = size(a,1);
% 
% res.a       = a;
% 
% res.v       = cumtrapz(a);
% res.vc      = zeros(size(a));
% 
% for t = 1:nSamples
%     res.vc(t,:) = res.v(t,:) + (res.v(t0,:)-res.v(T,:))*((t-t0+1)/(T-t0+1)) - res.v(t0,:);
% end
% 
% res.x   = cumtrapz(res.v);
% res.xc  = zeros(size(a));
% 
% for t = 1:nSamples
%     res.xc(t,:) = res.x(t,:) + (res.v(t0,:)-res.v(T,:))*((t-t0+1)^2)/(2*(T-t0+1)) - res.v(t0,:)*(t-t0+1) - res.x(t0,:);
% end
% 
% res.v  = res.v / frameRate;
% res.vc = res.vc / frameRate;
% res.x  = res.x / frameRate^2;
% res.xc = res.xc / frameRate^2;

figure;
subplot(2,4,1);
plot(res.a);
title('Global Accelerations');
subplot(2,4,2);
plot(res.v);
title('Velocities without correction');
subplot(2,4,3);
plot(res.x);
title('Positions without correction');
subplot(2,4,4);
plot3(res.x(:,1),res.x(:,2),res.x(:,3));
axis equal;
title('3D-positions without correction');
subplot(2,4,5);
plot(res.a);
title('Global accelerations');
subplot(2,4,6);
plot(res.vc);
title('Velocities with correction');
subplot(2,4,7);
plot(res.xc);
title('Positions with correction');
subplot(2,4,8);
plot3(res.xc(:,1),res.xc(:,2),res.xc(:,3));
axis equal;
title('3d-positions with correction');