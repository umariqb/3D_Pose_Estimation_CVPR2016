function htSkel = getSkelHeight2D(mot,varargin)

if(nargin == 2)
    motref = varargin{1};
end

if(isstruct(mot))
    allJoints = H_myFormatJoints(mot.inputDB);
    switch mot.inputDB
        case {'Human36Mbm','JHMDB','LeedSports'}
            idxHD       = H_getSingleJntIdx('Head',allJoints,1);
            idxNK       = H_getSingleJntIdx('Neck',allJoints,1);
            idxRH       = H_getSingleJntIdx('Right Hip',allJoints,1);
            idxRK       = H_getSingleJntIdx('Right Knee',allJoints,1);
            idxRA       = H_getSingleJntIdx('Right Ankle',allJoints,1);
            
            idxLH       = H_getSingleJntIdx('Left Hip',allJoints,1);
            idxLK       = H_getSingleJntIdx('Left Knee',allJoints,1);
            idxLA       = H_getSingleJntIdx('Left Ankle',allJoints,1);
            
            htHD_NK  = sqrt(sum((mot.jointTrajectories2D{idxHD}(:,:) - mot.jointTrajectories2D{idxNK}(:,:)).^2));
            
            rt = (mot.jointTrajectories2D{idxRH}(:,:) + mot.jointTrajectories2D{idxLH}(:,:))/2;
            
            htNK_RT  = sqrt(sum((mot.jointTrajectories2D{idxNK}(:,:) - rt).^2));
            
            htRH_RK  = sqrt(sum((mot.jointTrajectories2D{idxRH}(:,:) - mot.jointTrajectories2D{idxRK}(:,:)).^2));
            htRK_RA  = sqrt(sum((mot.jointTrajectories2D{idxRK}(:,:) - mot.jointTrajectories2D{idxRA}(:,:)).^2));
            htLH_LK  = sqrt(sum((mot.jointTrajectories2D{idxLH}(:,:) - mot.jointTrajectories2D{idxLK}(:,:)).^2));
            htLK_LA  = sqrt(sum((mot.jointTrajectories2D{idxLK}(:,:) - mot.jointTrajectories2D{idxLA}(:,:)).^2));
            
            htKne    = (htRH_RK + htLH_LK)/2;  % mean Left and right Knee
            htAnk    = (htRK_RA + htLK_LA)/2;  % mean Left and right ankle
            
            htSkel(f,1) = htHD_NK + htNK_RT + htKne + htAnk;
            
%             htH2N  = mean(sqrt((mot.jointTrajectories2D{idxHD}(:,:) - mot.jointTrajectories2D{idxNK}(:,:)).^2),2);
%             htN2A  = mean(sqrt((mot.jointTrajectories2D{idxNK}(:,:) - mot.jointTrajectories2D{idxAB}(:,:)).^2),2);
%             htA2R  = mean(sqrt((mot.jointTrajectories2D{idxAB}(:,:) - mot.jointTrajectories2D{idxRT}(:,:)).^2),2);
%             htR2K  = mean(sqrt((mot.jointTrajectories2D{idxRT}(:,:) - mot.jointTrajectories2D{idxRK}(:,:)).^2),2);
%             htK2A  = mean(sqrt((mot.jointTrajectories2D{idxRK}(:,:) - mot.jointTrajectories2D{idxRA}(:,:)).^2),2);
%             
%             htSkel = htH2N + htN2A + htA2R + htR2K + htK2A;
        case 'Human80K'
            idxHD       = H_getSingleJntIdx('Head',allJoints,1);
            idxNK       = H_getSingleJntIdx('Neck',allJoints,1);
            idxAB       = H_getSingleJntIdx('Abdomen',allJoints,1);
            idxRT       = H_getSingleJntIdx('Root',allJoints,1);
            idxRK       = H_getSingleJntIdx('Right Knee',allJoints,1);
            idxRA       = H_getSingleJntIdx('Right Ankle',allJoints,1);
            
            htH2N  = mean(sqrt((mot.jointTrajectories2D{idxHD}(:,:) - mot.jointTrajectories2D{idxNK}(:,:)).^2),2);
            htN2A  = mean(sqrt((mot.jointTrajectories2D{idxNK}(:,:) - mot.jointTrajectories2D{idxAB}(:,:)).^2),2);
            htA2R  = mean(sqrt((mot.jointTrajectories2D{idxAB}(:,:) - mot.jointTrajectories2D{idxRT}(:,:)).^2),2);
            htR2K  = mean(sqrt((mot.jointTrajectories2D{idxRT}(:,:) - mot.jointTrajectories2D{idxRK}(:,:)).^2),2);
            htK2A  = mean(sqrt((mot.jointTrajectories2D{idxRK}(:,:) - mot.jointTrajectories2D{idxRA}(:,:)).^2),2);
            
            htSkel = htH2N + htN2A + htA2R + htR2K + htK2A;
            
        case 'HumanEva'
            idxHd  = find(strcmp('Head', allJoints));
            idxLF  = find(strcmp('Left Ankle', allJoints));
            idxRF  = find(strcmp('Right Ankle', allJoints));
            mnFeet = (mot.jointTrajectories2D{idxLF}(:,:) + mot.jointTrajectories2D{idxRF}(:,:))/2;
            htSkel  = mot.jointTrajectories2D{idxHd}(:,:) - mnFeet;
        otherwise
            disp('H-errror: please specify inputDB name in function H_getSkelHeight2D');
    end
else
    if(exist('motref','var'))
        allJoints = H_myFormatJoints(motref.inputDB);
        switch motref.inputDB
            case {'Human36Mbm','JHMDB','LeedSports'}
            idxHD       = getSingleJntIdx('Head',allJoints,1);
            idxNK       = getSingleJntIdx('Neck',allJoints,1);
            idxRH       = getSingleJntIdx('Right Hip',allJoints,1);
            idxRK       = getSingleJntIdx('Right Knee',allJoints,1);
            idxRA       = getSingleJntIdx('Right Ankle',allJoints,1);
            
            idxLH       = getSingleJntIdx('Left Hip',allJoints,1);
            idxLK       = getSingleJntIdx('Left Knee',allJoints,1);
            idxLA       = getSingleJntIdx('Left Ankle',allJoints,1);
            
            htHD_NK  = sqrt(sum((mot(idxHD,:) - mot(idxNK,:)).^2));
            
            rt = (mot(idxRH,:) + mot(idxLH,:))/2;
            
            htNK_RT  = sqrt(sum((mot(idxNK,:) - rt).^2));
            
            htRH_RK  = sqrt(sum((mot(idxRH,:) - mot(idxRK,:)).^2));
            htRK_RA  = sqrt(sum((mot(idxRK,:) - mot(idxRA,:)).^2));
            htLH_LK  = sqrt(sum((mot(idxLH,:) - mot(idxLK,:)).^2));
            htLK_LA  = sqrt(sum((mot(idxLK,:) - mot(idxLA,:)).^2));
            
            htKne    = (htRH_RK + htLH_LK)/2;  % mean Left and right Knee
            htAnk    = (htRK_RA + htLK_LA)/2;  % mean Left and right ankle
            
            htSkel = htHD_NK + htNK_RT + htKne + htAnk;
            
%             htH2N  = mean(sqrt((mot.jointTrajectories2D{idxHD}(:,:) - mot.jointTrajectories2D{idxNK}(:,:)).^2),2);
%             htN2A  = mean(sqrt((mot.jointTrajectories2D{idxNK}(:,:) - mot.jointTrajectories2D{idxAB}(:,:)).^2),2);
%             htA2R  = mean(sqrt((mot.jointTrajectories2D{idxAB}(:,:) - mot.jointTrajectories2D{idxRT}(:,:)).^2),2);
%             htR2K  = mean(sqrt((mot.jointTrajectories2D{idxRT}(:,:) - mot.jointTrajectories2D{idxRK}(:,:)).^2),2);
%             htK2A  = mean(sqrt((mot.jointTrajectories2D{idxRK}(:,:) - mot.jointTrajectories2D{idxRA}(:,:)).^2),2);
%             
%             htSkel = htH2N + htN2A + htA2R + htR2K + htK2A;
            case 'Human80K'
                idxHD       = getSingleJntIdx('Head',allJoints,2);
                idxNK       = getSingleJntIdx('Neck',allJoints,2);
                idxAB       = getSingleJntIdx('Abdomen',allJoints,2);
                idxRT       = getSingleJntIdx('Root',allJoints,2);
                idxRK       = getSingleJntIdx('Right Knee',allJoints,2);
                idxRA       = getSingleJntIdx('Right Ankle',allJoints,2);
                
                htH2N  = mean(sqrt((mot(idxHD,:) - mot(idxNK,:)).^2),2);
                htN2A  = mean(sqrt((mot(idxNK,:) - mot(idxAB,:)).^2),2);
                htA2R  = mean(sqrt((mot(idxAB,:) - mot(idxRT,:)).^2),2);
                htR2K  = mean(sqrt((mot(idxRT,:) - mot(idxRK,:)).^2),2);
                htK2A  = mean(sqrt((mot(idxRK,:) - mot(idxRA,:)).^2),2);
                
                htSkel = htH2N + htN2A + htA2R + htR2K + htK2A;
            case 'HumanEva'
                idxHd  = find(strcmp('Head', allJoints));
                idxLF  = find(strcmp('Left Ankle', allJoints));
                idxRF  = find(strcmp('Right Ankle', allJoints));
                hd     = (idxHd-1)*2+1;
                lf     = (idxLF-1)*2+1;
                rf     = (idxRF-1)*2+1;
                
                mnFeet = (mot(lf:lf+1,:) + mot(rf:rf+1,:))/2;
                htSkel  = mot(hd:hd+1,:) - mnFeet;
            otherwise
                disp('H-errror: please specify inputDB name in function H_getSkelHeight2D');
        end
    else
        idxHd  = 5;
        idxLF  = 1;
        idxRF  = 2;
        hd     = (idxHd-1)*2+1;
        lf     = (idxLF-1)*2+1;
        rf     = (idxRF-1)*2+1;
        
        mnFeet = (mot(lf:lf+1,:) + mot(rf:rf+1,:))/2;
        htSkel = mot(hd:hd+1,:) - mnFeet;
    end
    
    
end
end