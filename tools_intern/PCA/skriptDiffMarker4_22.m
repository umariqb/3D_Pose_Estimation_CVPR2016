function res=skriptDiffMarker4_22(motMat,PCAmat,skel)

res=cell(size(motMat));

for a=1:size(motMat,1)
    for b=1:size(motMat,2)
     
        
fprintf('\n\n\n\n\n\n\n\n\n\n MATRIX(%i , %i )\n\n\n',a,b);
        
mot=motMat{a,b}.orgMot;

mot=changeFrameRate(skel,mot,30);
mot=fitMotion(skel,mot);
mot=cutMot_jt(mot,motMat{a,b}.startFrame,motMat{a,b}.endFrame);
        
        
res{a,b}.M_4_22      =reconstructMotionPCAbased ...
                                (skel,mot,PCAmat,[ 4 22]);
                 

save('PCArecTMP4_22.mat','res');

    end
end
end
