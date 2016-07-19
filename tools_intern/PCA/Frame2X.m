function res=Frame2X(frame,jointList,dataRep)

switch lower(dataRep)
    
    case 'quat'
        res=cell2mat(frame.rotationQuat(jointList));
    case {'position','pos'}
        res=cell2mat(frame.jointTrajectories(jointList));
    case 'euler'
        res=cell2mat(frame.rotationEuler(jointList));
    otherwise
        error('Frame2X: Used DataRep is not implemented yet!');
end