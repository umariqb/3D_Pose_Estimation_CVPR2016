function T = findOptimalPCtransformation(pc1,pc2)

% pc1(1,:)=pc1(1,:)*9.81;
% pc1(2,:)=-pc1(2,:);
% pc1(3,:)=pc1(3,:)/9.81;

T.pc1 = pc1;
T.pc2 = pc2;

T.pc1_abs = normOfColumns(T.pc1);
T.pc2_abs = normOfColumns(T.pc2);

figure()
plot(T.pc1_abs);
hold all
plot(T.pc2_abs);
hold off
drawnow;




figure()
plot(T.pc1');
hold all
plot(T.pc2');
hold off
drawnow;

% startValue  = [0 0 0 1];
% lb          = [-2*pi -2*pi -2*pi 0];
% ub          = [ 2*pi  2*pi  2*pi 2];

startValue  = [0 0 0];
lb          = [-2*pi -2*pi -2*pi];
ub          = [ 2*pi  2*pi  2*pi];

options = optimset( 'Display','iter' ,...
                    'MaxFunEvals',100000,...
                    'MaxIter',100,...
                    'TolFun',0.001);%,...
%                     'PlotFcns', @optimplotx);

X = lsqnonlin(@(x) objfunLocal(x,pc1,pc2),startValue,lb,ub,options);

T.rotation  = X(1:3);
%  T.scale     = X(4:6);

T.qR        = C_euler2quat(X(1:3)');
% T.pc1_new   = C_quatrot(pc1,T.qR) .* repmat(T.scale',1,size(T.pc1,2));
T.pc1_new   = C_quatrot(pc1,T.qR);

figure
subplot(3,1,1);plot(T.pc1')
subplot(3,1,2);plot(T.pc2')
subplot(3,1,3);plot(T.pc1_new')
drawnow();

figure()
plot(T.pc1_new');
hold all
plot(T.pc2');
hold off
drawnow;

end

%% local functions

function f = objfunLocal(x,pc1,pc2)

% qx = rotquat(x(1),'x');
% qy = rotquat(x(2),'y');
% qz = rotquat(x(3),'z');
% q = C_quatmult(qz,C_quatmult(qy,qx));
% pc1(1,:)=pc1(1,:)*x(4);
% pc1(2,:)=pc1(1,:)*x(5);
% pc1(3,:)=pc1(1,:)*x(6);

q = C_euler2quat(x(1:3)');
% f = C_quatrot(pc1,q) * x(4) - pc2;
f = C_quatrot(pc1,q) - pc2;

end