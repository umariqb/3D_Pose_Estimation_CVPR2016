function [res,mot]=reconstructMotionPCAbasedOnWindows ...
                            (skel,mot,KDMAT,jointList)

                                              
res=emptyMotion();

res.njoints     =mot.njoints;
res.frameTime   =mot.frameTime;
res.samplingRate=mot.samplingRate;

res.jointNames=mot.jointNames;
res.boneNames =mot.boneNames;
res.nameMap   =mot.nameMap;
res.animated  =mot.animated;
res.unanimated=mot.unanimated;
res.filename  ='Rec from PCA on Windows';
res.documentation=mot.documentation;
res.angleUnit = mot.angleUnit;
res.jointTrajectories=cell(res.njoints,1);
res.rotationQuat=cell(res.njoints,1);

optProps=newOptProbs(jointList);


% [skel,fitmot]=extractMotion(Tensor,[1 1 1]);
% 
% [D,w]=SimpleDTW(fitmot,skel,mot);
%  mot = warpMotion(w,skel,mot);

mot=removeTranslation(skel,mot);
mot=removeOrientation(skel,mot);

mot = fitMotion(skel,mot);
mot = addAccToMot(mot);




% tree=kdtree(PCAMat.data');

for f=1:mot.nframes
   
    optProps.actFrame=f;
    
    oFrame=extractFrame(mot,f);
   
   KDsample=Frame2X(oFrame,KDMAT.jointList,KDMAT.treeDataRep);
   
%    PCAMatWin=extractPCAMatForWindow(f,f+winlength,PCAMat);
   PCAMatWin=findNeighboursKDTree(KDsample,KDMAT.tree,KDMAT.PCAData,KDMAT.PCADataRep);
   
   fprintf('\n\n\n\n Frame: %i \n\n\n\n',f);
   
   [rFrame,optProps]=findCoefficientsFramePCA(skel,oFrame,PCAMatWin,optProps);
   
   res=addFrame2Motion(res,rFrame);
end

res.jointTrajectories=forwardKinematicsQuat(skel,res);