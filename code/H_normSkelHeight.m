function treeData = H_normSkelHeight(database,treeData,opts)

switch database
    case {'Human36Mbm','CMU_H36M','HumanEva_H36M','CMU_30','default'}
        idxHD       = H_getSingleJntIdx('Head',opts.allJoints,3);
        idxNK       = H_getSingleJntIdx('Neck',opts.allJoints,3);

        idxRH       = H_getSingleJntIdx('Right Hip',opts.allJoints,3);
        idxRK       = H_getSingleJntIdx('Right Knee',opts.allJoints,3);
        idxRA       = H_getSingleJntIdx('Right Ankle',opts.allJoints,3);
        
        idxLH       = H_getSingleJntIdx('Left Hip',opts.allJoints,3);
        idxLK       = H_getSingleJntIdx('Left Knee',opts.allJoints,3);
        idxLA       = H_getSingleJntIdx('Left Ankle',opts.allJoints,3);        
        
        htHD_NK  = sqrt(sum((treeData(idxHD,:) - treeData(idxNK,:)).^2));
        
        %%%rt = (treeData(idxRH,:) + treeData(idxLH,:));
        rt = (treeData(idxRH,:) + treeData(idxLH,:))/2;
        
        htNK_RT  = sqrt(sum((treeData(idxNK,:) - rt).^2));
        
        htRH_RK  = sqrt(sum((treeData(idxRH,:) - treeData(idxRK,:)).^2));
        htRK_RA  = sqrt(sum((treeData(idxRK,:) - treeData(idxRA,:)).^2));
        htLH_LK  = sqrt(sum((treeData(idxLH,:) - treeData(idxLK,:)).^2));
        htLK_LA  = sqrt(sum((treeData(idxLK,:) - treeData(idxLA,:)).^2));
        
        htKne    = (htRH_RK + htLH_LK)/2;  % mean Left and right Knee
        htAnk    = (htRK_RA + htLK_LA)/2;  % mean Left and right ankle
        
        htSkel = htHD_NK + htNK_RT + htKne + htAnk;
        htSkel = htSkel/2; % iccv
        %htSkel = htSkel/1.5;
        htSkel = repmat(htSkel,size(treeData,1),[]);
        treeData = treeData./htSkel;
    case 'Human80K'        
        idxHD       = H_getSingleJntIdx('Head',opts.allJoints,3);
        idxNK       = H_getSingleJntIdx('Neck',opts.allJoints,3);
        idxAB       = H_getSingleJntIdx('Abdomen',opts.allJoints,3);
        idxRT       = H_getSingleJntIdx('Root',opts.allJoints,3);
        
        idxRH       = H_getSingleJntIdx('Right Hip',opts.allJoints,3);
        idxRK       = H_getSingleJntIdx('Right Knee',opts.allJoints,3);
        idxRA       = H_getSingleJntIdx('Right Ankle',opts.allJoints,3);
        
        idxLH       = H_getSingleJntIdx('Left Hip',opts.allJoints,3);
        idxLK       = H_getSingleJntIdx('Left Knee',opts.allJoints,3);
        idxLA       = H_getSingleJntIdx('Left Ankle',opts.allJoints,3);        
        
        htHD_NK  = sqrt(sum((treeData(idxHD,:) - treeData(idxNK,:)).^2));
        htNK_AB  = sqrt(sum((treeData(idxNK,:) - treeData(idxAB,:)).^2));
        htAB_RT  = sqrt(sum((treeData(idxAB,:) - treeData(idxRT,:)).^2));
        
        htRH_RK  = sqrt(sum((treeData(idxRH,:) - treeData(idxRK,:)).^2));
        htRK_RA  = sqrt(sum((treeData(idxRK,:) - treeData(idxRA,:)).^2));
        htLH_LK  = sqrt(sum((treeData(idxLH,:) - treeData(idxLK,:)).^2));
        htLK_LA  = sqrt(sum((treeData(idxLK,:) - treeData(idxLA,:)).^2));
        
        htKne    = (htRH_RK + htLH_LK)/2;  % mean Left and right Knee
        htAnk    = (htRK_RA + htLK_LA)/2;  % mean Left and right ankle
        
        htSkel = htHD_NK + htNK_AB + htAB_RT + htKne + htAnk;
        htSkel = htSkel/2;
        htSkel = repmat(htSkel,size(treeData,1),[]);
        treeData = treeData./htSkel;
    otherwise
        disp('H-error: H_normSkelHeight:- please specify correct database ... ');
end
