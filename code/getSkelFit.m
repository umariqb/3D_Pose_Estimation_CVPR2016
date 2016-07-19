function mot = getSkelFit(mot,nt2D,varargin)
%%
disH2F      = getSkelHeight2D(nt2D,mot);
mndisH2F    = mean(disH2F,2);

disH2Fmot   = getSkelHeight2D(mot);
mndisH2Fmot = mean(disH2Fmot,2);

nd          = disH2Fmot./repmat(mndisH2F,1,mot.nframes);



mot.jointTrajectories2DN = mot.jointTrajectories2D;
if(nargin>2)
    for t =1: mot.njoints
%         mot.jointTrajectories2DN{t}(1,:) = mot.jointTrajectories2D{t}(1,:)/mndisH2F(1);
%         mot.jointTrajectories2DN{t}(2,:) = mot.jointTrajectories2D{t}(2,:)/mndisH2F(2);
        mot.jointTrajectories2DN{t}(1,:) = mot.jointTrajectories2D{t}(1,:)./nd(2,:);
        mot.jointTrajectories2DN{t}(2,:) = mot.jointTrajectories2D{t}(2,:)./nd(2,:);
    end
else
    for t =1: mot.njoints
        mot.jointTrajectories2DN{t}(1,:) = mot.jointTrajectories2D{t}(1,:);
        mot.jointTrajectories2DN{t}(2,:) = mot.jointTrajectories2D{t}(2,:)./nd(2,:);
    end
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