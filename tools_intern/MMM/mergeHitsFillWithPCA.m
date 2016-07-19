function [finalMot,hits]=mergeHitsFillWithPCA(hits,Tensor)

hits.numHitsPerFrame=countHitsPerFrame(hits);




finalMot=0;