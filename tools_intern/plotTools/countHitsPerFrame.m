function res=countHitsPerFrame(hits)

res=zeros(1,hits.orgNumFrames);
for hit=1:hits.numHits
    start=hits.startFrames(hit);
    ende =hits.endFrames(hit);
    res(start:ende)=res(start:ende)+1;
end
