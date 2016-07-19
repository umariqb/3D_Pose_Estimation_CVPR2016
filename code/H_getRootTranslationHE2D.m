function [mot, rootP2D] = H_getRootTranslationHE2D(mot,opts)
if(isstruct(mot))
    switch mot.inputDB
        case 'Human80K'
            idxRt       = find(strcmp('Root', mot.jointNames(:)));
            rootP2D     = mot.jointTrajectories2D{idxRt}(:,:) ;
            mot.rootP2D = rootP2D;
            for n = 1:mot.njoints
                mot.jointTrajectories2D{n}(:,:)  = (mot.jointTrajectories2D{n}(:,:) - rootP2D(:,:));
            end
        case {'HumanEva','Human36Mbm','JHMDB','LeedSports'}
            idxLH       = find(strcmp('Left Hip', mot.jointNames(:)));
            idxRH       = find(strcmp('Right Hip', mot.jointNames(:)));
            rootP2D     = (mot.jointTrajectories2D{idxLH}(:,:) + mot.jointTrajectories2D{idxRH}(:,:))/2;
            mot.rootP2D = rootP2D;
            for n = 1:mot.njoints
                mot.jointTrajectories2D{n}(:,:)  = (mot.jointTrajectories2D{n}(:,:) - rootP2D(:,:));
            end
        otherwise
            disp('H-error: please specify inputDB in function H_getRootTranslationHE2D ... ');
    end
else
    if(iscell(opts.cJoints) && ischar(opts.cJoints{1}))
        idxLH   = find(strcmp('Left Hip', opts.cJoints(:)));
        idxRH   = find(strcmp('Right Hip',opts.cJoints(:)));
    else
        idxLH   = 12;
        idxRH   = 13;
    end
    lh      = (idxLH-1)*2+1;
    rh      = (idxRH-1)*2+1;
    rootP2D = (mot(lh:lh+1,:) + mot(rh:rh+1,:))/2;
    mot     = mot - repmat(rootP2D,opts.cJointsNo,1);
end
end
