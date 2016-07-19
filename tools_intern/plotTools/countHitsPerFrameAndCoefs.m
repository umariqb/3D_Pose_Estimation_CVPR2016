function [hpF,coeffs,styleList]=countHitsPerFrameAndCoefs(hits)

hpF=zeros(1,hits.orgNumFrames);
for hit=1:hits.numHits
    start=hits.startFrames(hit);
    ende =hits.endFrames(hit)-1;
    hpF(start:ende)=hpF(start:ende)+1;
end

maxHits=max(hpF(:));
numCoefs=0;
styleList{1,1}='dummy';

for hit=1:hits.numHits
    numCoefs=numCoefs+size(hits.hitProperties{hit}.res.coeffsX{1,1},2);
    
    for style=1:size(hits.hitProperties{hit}.styles,2)
        contains=strfind(styleList,hits.hitProperties{hit}.styles{style});
        gra=0;
        for gr=1:size(contains,2)
            if      ~isempty(contains{gr}) && ...
                    (length(styleList{gr})==length(hits.hitProperties{hit}.styles{style}))
                
                gra=gra + 1;
                
            end
        end
        if gra==0
            styleList=[styleList hits.hitProperties{hit}.styles{style}];
        end
    end
end

styleList=styleList(2:end);

for styleInd=1:size(styleList,2)
   
    coeffs.(styleList{styleInd})=nan(1,hits.orgNumFrames);
    
end

for hit=1:hits.numHits
   
    for style=1:size(hits.hitProperties{hit}.styles,2)
        line=nan(1,hits.orgNumFrames);
        line(hits.hitProperties{hit}.startFrame:hits.hitProperties{hit}.endFrame-1) = ...
                hits.hitProperties{hit}.res.coeffsX{1}(style);
        coeffs.(hits.hitProperties{hit}.styles{style}) = ...
                [coeffs.(hits.hitProperties{hit}.styles{style}) ; ...
                  line  ];
    end
end