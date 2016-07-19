function f = objfunCol(x,Tensor,newMot,nrOfNaturalModes, ...
                    nrOfTechnicalModes,dimvec,varargin)
    
for i=1:nrOfNaturalModes
    X{i}=x(1:dimvec(i+nrOfTechnicalModes));
    x=x(dimvec(i+nrOfTechnicalModes)+1:size(x,2));
end

switch nargin
    case 6
       skel = readASF(Tensor.skeletons{1,1});
       DataRep='Quat';
    case 7
        skel=varargin{1};
        DataRep='Quat';
    case 8
        skel=varargin{1};
        DataRep=varargin{2};
    otherwise
        disp('Wrong number of arguments');
end

[skel,mot]=constructMotionNoTechColumn(Tensor,X,skel,DataRep);

% f=compareMotions(mot,newMot,'jointAngle',skel);
% f=compareMotions(mot,newMot,'Acce');
f=compareMotions(mot,newMot,DataRep);

% f=f(:).*f(:);
%f=f*f;

% fprintf('\nD= %3.3f\n\n',D);
%animate(skel,mot);
