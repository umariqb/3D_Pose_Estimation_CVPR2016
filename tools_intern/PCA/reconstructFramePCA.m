function R=reconstructFramePCA(skel,O,Data,DataRep)

R=O;

switch lower(DataRep)
    case 'quat'

        for j=1:R.njoints
            R.rotationQuat{j}=Data(1:4);
            Data=Data(5:end);
        end
        
        R.rotationQuat{1}=O.rotationQuat{1};

        R.jointTrajectories=forwardKinematicsQuat(skel,R);
        R.boundingbox=computeBoundingBox(R);
        
        R.rotationQuat(R.unanimated)={[]};
        
    case  'expmap'
        Data=Data(4:end);
        for j=2:R.njoints
            R.rotationQuat{j}=quatexp(Data(1:3));
            Data=Data(4:end);
        end
        
        R.jointTrajectories=forwardKinematicsQuat(skel,R);
        R.boundingbox=computeBoundingBox(R);
        
    case  'acc'
        for j=1:R.njoints
            R.jointAccelerations{j}=Data(1:3);
            Data=Data(4:end);
        end
        
        
        
        R.jointTrajectories=forwardKinematicsQuat(skel,R);
        R.boundingbox=computeBoundingBox(R);
        
    otherwise
        error('reconstructFramePCA: Your DateRep is not implemented!');
end

