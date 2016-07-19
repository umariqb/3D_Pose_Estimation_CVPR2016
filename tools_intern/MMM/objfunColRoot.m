function f = objfunColRoot(x,Tensor,newMot,nrOfNaturalModes, ...
                    nrOfTechnicalModes,dimvec,varargin)
    
for i=1:nrOfNaturalModes
    X{i}=x(1:dimvec(i));
    x=x(dimvec(i)+1:size(x,2));
end

nrOfTechnicalModes=Tensor.numTechnicalModes;

for i=size(X,2):-1:1
    ii=nrOfTechnicalModes+i-1;
    Tensor.rootcore = modeNproduct( ...
                        Tensor.rootcore, ...
                        X{i},ii);
end

rootTranslation=Tensor.rootcore(:,:);

[f,theta,x0,z0] = pointCloudDist_modified(newMot.rootTranslation,rootTranslation);

% Trafo matrix:
T(1,:) = [ cos(theta)   0 sin(theta) x0 ];
T(2,:) = [ 0            1 0          0  ];
T(3,:) = [ -sin(theta)  0 cos(theta) z0 ];
T(4,:) = [ 0            0 0          1  ];

rootTranslation=T*[rootTranslation; ones(1,size(rootTranslation,2))];


if false
    subplot(1,1,1);
    plot3(newMot.rootTranslation(1,:),newMot.rootTranslation(2,:),newMot.rootTranslation(3,:),'.');
    hold on
    plot3(rootTranslation(1,:),rootTranslation(2,:),rootTranslation(3,:),'red');
    hold off
    axis([min(newMot.rootTranslation(1,:)) max(newMot.rootTranslation(1,:)) ...
          min(newMot.rootTranslation(2,:)) max(newMot.rootTranslation(2,:))...
          min(newMot.rootTranslation(3,:)) max(newMot.rootTranslation(3,:))]);
%     axis([min(newMot.rootTranslation(:)) max(newMot.rootTranslation(:)) ...
%           min(newMot.rootTranslation(:)) max(newMot.rootTranslation(:)) ...
%           min(newMot.rootTranslation(:)) max(newMot.rootTranslation(:)) ...
%          ]);
    drawnow();
end

% f=f^2;
f=newMot.rootTranslation-rootTranslation(1:3,:);

end
