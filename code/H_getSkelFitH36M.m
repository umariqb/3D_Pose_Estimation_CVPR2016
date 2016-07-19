function mot = H_getSkelFitH36M(mot,nt2D,varargin)
%%
disH2F      = getSkelHeight2D(nt2D,mot);
mndisH2F    = mean(disH2F,2);
allJoints   = H_myFormatJoints(mot.inputDB);

mot.jointTrajectories2DN = mot.jointTrajectories2D;

for f = 1:mot.nframes
    idxHD       = getSingleJntIdx('Head',allJoints,1);
    idxNK       = getSingleJntIdx('Neck',allJoints,1);
    idxRH       = getSingleJntIdx('Right Hip',allJoints,1);
    idxRK       = getSingleJntIdx('Right Knee',allJoints,1);
    idxRA       = getSingleJntIdx('Right Ankle',allJoints,1);
    
    idxLH       = getSingleJntIdx('Left Hip',allJoints,1);
    idxLK       = getSingleJntIdx('Left Knee',allJoints,1);
    idxLA       = getSingleJntIdx('Left Ankle',allJoints,1);
    
%     htH2N  = sqrt((mot.jointTrajectories2D{idxHD}(:,f) - mot.jointTrajectories2D{idxNK}(:,f)).^2);
%     htN2A  = sqrt((mot.jointTrajectories2D{idxNK}(:,f) - mot.jointTrajectories2D{idxAB}(:,f)).^2);
%     htA2R  = sqrt((mot.jointTrajectories2D{idxAB}(:,f) - mot.jointTrajectories2D{idxRT}(:,f)).^2);
%     htR2K  = sqrt((mot.jointTrajectories2D{idxRT}(:,f) - mot.jointTrajectories2D{idxRK}(:,f)).^2);
%     htK2A  = sqrt((mot.jointTrajectories2D{idxRK}(:,f) - mot.jointTrajectories2D{idxRA}(:,f)).^2);
%     htSkel(f,1) = (htH2N(2) + htN2A(2) + htA2R(2) + htR2K(2) + htK2A(2));
%     htSkel(f,1) = (htN2A(2) + htA2R(2) + htR2K(2) + htK2A(2));
%     %htSkel(f,1) = (htH2N(2) + htN2A(2) + htA2R(2) );

    htHD_NK  = sqrt(sum((mot.jointTrajectories2D{idxHD}(:,f) - mot.jointTrajectories2D{idxNK}(:,f)).^2));
    
    rt = (mot.jointTrajectories2D{idxRH}(:,f) + mot.jointTrajectories2D{idxLH}(:,f))/2;

    htNK_RT  = sqrt(sum((mot.jointTrajectories2D{idxNK}(:,f) - rt).^2));
    
    htRH_RK  = sqrt(sum((mot.jointTrajectories2D{idxRH}(:,f) - mot.jointTrajectories2D{idxRK}(:,f)).^2));
    htRK_RA  = sqrt(sum((mot.jointTrajectories2D{idxRK}(:,f) - mot.jointTrajectories2D{idxRA}(:,f)).^2));    
    htLH_LK  = sqrt(sum((mot.jointTrajectories2D{idxLH}(:,f) - mot.jointTrajectories2D{idxLK}(:,f)).^2));
    htLK_LA  = sqrt(sum((mot.jointTrajectories2D{idxLK}(:,f) - mot.jointTrajectories2D{idxLA}(:,f)).^2));
    
    htKne    = (htRH_RK + htLH_LK)/2;  % mean Left and right Knee
    htAnk    = (htRK_RA + htLK_LA)/2;  % mean Left and right ankle

    htSkel(f,1) = htHD_NK + htNK_RT + htKne + htAnk;
    
end
%%%%%%%%%%%%%%%%%%%
htSkelOrig = htSkel;
thresh = 50;
htSkelmn = mean(htSkel);
ind = find(abs(htSkel-htSkelmn)<thresh);
htSkel(ind)  = htSkelmn;
%%%%%%%%%%%%%%%%%%%%
htSkel = htSkel/2;

for t =1: mot.njoints
    mot.jointTrajectories2DN{t}(1,:) = mot.jointTrajectories2D{t}(1,:)./htSkel(:,1)';
    mot.jointTrajectories2DN{t}(2,:) = mot.jointTrajectories2D{t}(2,:)./htSkel(:,1)';
end

end


%%
% %     mhtp = mean(mot.jointTrajectories2DN{5},2);
% %     mhdb = mean(nt2D(9:10,:),2);
% %     obj_pos(2:3:end,:) = (obj_pos(2:3:end,:)/mhdb(2))*mhtp(2);
% idxHd  = find(strcmp('Head', mot.jointNames(:)));
% nd  = mot.jointTrajectories2D{idxHd}(:,:);
%
% ndm= mean(nd,2);