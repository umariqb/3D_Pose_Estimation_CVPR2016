function tmpMatrix=extractFrameData(mot,varargin)

switch nargin
    case 1       
        dataRep='Quat';
    case 2
        dataRep=varargin{1};
    otherwise
        error('extractFrameData: Wrong number of Args!\n');
end

for joint=1:mot.njoints
%                     Tensor.joints{joint,s,a,r}=mot.jointNames{joint};
    switch dataRep
        case 'Quat'
            if(~isempty(mot.rotationQuat{joint}))
                tmpMatrix(joint*4-3:joint*4,:)=mot.rotationQuat{joint};
            else
                tmpMatrix(joint*4-3,:)        = ones(1,mot.nframes);
                tmpMatrix(joint*4-2:joint*4,:)=zeros(3,mot.nframes);
            end
        case 'Position'
            error('Not implemented');
        case 'ExpMap'
            if(~isempty(mot.rotationQuat{joint}))
                tmpMatrix(joint*3-2:joint*3,:)=quatlog(mot.rotationQuat{joint});
            else
                tmpMatrix(joint*3-2:joint*3,:)=zeros(3,mot.nframes);
            end
        case 'Acc'
            tmpMatrix(joint*3-2:joint*3,:)=mot.jointAccelerations{joint};     
        otherwise 
            error('buildTensorStyleActRep_jt: Wrong Type specified in var: dataRep\n');
    end
end