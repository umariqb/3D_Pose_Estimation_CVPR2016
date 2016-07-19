function [res,maxi,mini]=averageError4File(hits)

    distperframe=[];

    for hitInd=1:hits.numHits
        
        distperframe=[distperframe hits.hitProperties{1,hitInd}.distUnWarp.dist_perframe_cm];
        
    end
    
%     plot(distperframe);

    maxi=max(distperframe(:));
    mini=min(distperframe(:));
    
    res=sum(distperframe(:))/size(distperframe,2);

end
