function Matrix=extractPCAMatFromTensor(T)

% Collect Data from Tensor

% tmpMatrix=zeros(T.dimTechnicalModes(1)*T.dimTechnicalModes(3), ...
%                 T.dimNaturalModes(2)*prod(T.dimNaturalModes));

fprintf('Reconstructing [skel,mot] \t\t\t');

Matrix.data=[];

for a=1:T.dimNaturalModes(1)
    for b=1:T.dimNaturalModes(2)
        for c=1:T.dimNaturalModes(3)
            fprintf('\b\b\b%i%i%i',a,b,c);
            [skel,mot]=extractMotion(T,[a,b,c],T.DataRep);
            mot=addVelToMot(mot);
            mot=addAccToMot(mot);
            
            for joint=1:mot.njoints
%                     Tensor.joints{joint,s,a,r}=mot.jointNames{joint};
                    switch lower(T.DataRep)
                        case 'quat'
                            if(~isempty(mot.rotationQuat{joint}))
                                tmpMatrix(joint*4-3:joint*4,:)=mot.rotationQuat{joint};
                            else
                                tmpMatrix(joint*4-3,:)        = ones(1,mot.nframes);
                                tmpMatrix(joint*4-2:joint*4,:)=zeros(3,mot.nframes);
                            end
                        case {'position','pos'}
                            error('Not implemented');
                        case 'expmap'
                            if(~isempty(mot.rotationQuat{joint}))
                                tmpMatrix(joint*3-2:joint*3,:)=quatlog(mot.rotationQuat{joint});
                            else
                                tmpMatrix(joint*3-2:joint*3,:)=zeros(3,mot.nframes);
                            end
                        case 'acc'
                            tmpMatrix(joint*3-2:joint*3,:)=mot.jointAccelerations{joint};     
                        otherwise 
                            error('extractPCAMatForWindow: Wrong Type specified in var: dataRep\n');
                    end
             end
                
             Matrix.data=[Matrix.data tmpMatrix];
        end
            
    end
end
    
% Calculate interesting stuff ...

% [Matrix.rootcoefs,Matrix.rootscores,Matrix.rootvariances,Matrix.roott2]...
%                = princomp(Matrix.rootdata');
           
[Matrix.coefs,Matrix.scores,Matrix.variances,Matrix.t2] ...
               = princomp(Matrix.data');

Matrix.mean    =mean(Matrix.data,2);
% Matrix.rootmean=mean(Matrix.rootdata,2);

Matrix.cov     =cov(Matrix.data');
% Matrix.rootCov =cov(Matrix.rootdata');

Matrix.inv     =pinv(Matrix.cov');
% Matrix.rootInv =pinv(Matrix.rootCov');

Matrix.DataRep=T.DataRep;
Matrix.nframes=mot.nframes;

end