function Y = H_rigid_motionShort(X,om,T)

%[R,dRdom] = rodrigues(om);
R = H_rodriguesShort(om);
[m,n] = size(X);
Y = R*X + repmat(T,[1 n]);

end




