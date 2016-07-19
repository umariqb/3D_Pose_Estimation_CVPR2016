function res=plotRecErrors(hits)

res=nan(hits.numHits,hits.orgNumFrames);

for hitInd=1:hits.numHits
    res(hitInd,hits.startFrames(hitInd):hits.endFrames(hitInd))=...
        hits.hitProperties{1,hitInd}.distUnWarp.dist_perframe_cm;
end

% figure();
plot(res','lineWidth',3);