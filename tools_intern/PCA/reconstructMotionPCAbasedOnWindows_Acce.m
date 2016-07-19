function res=reconstructMotionPCAbasedOnWindows_Acce(skel,mot,Tensor,jointList, winlength)

res=emptyMotion();

res.njoints     =mot.njoints;
res.frameTime   =mot.frameTime;
res.samplingRate=mot.samplingRate;

res.jointNames=mot.jointNames;
res.boneNames =mot.boneNames;
res.nameMap   =mot.nameMap;
res.animated  =mot.animated;
res.unanimated=mot.unanimated;
res.filename  ='Rec from PCA';
res.documentation=mot.documentation;
res.angleUnit = mot.angleUnit;
res.jointTrajectories=cell(res.njoints,1);
res.rotationQuat=cell(res.njoints,1);

optProps=newOptProbs(jointList);
optProps.recmot=res;

[skel,fitmot]=extractMotion(Tensor,[1 1 1]);

[D,w]=SimpleDTW(fitmot,skel,mot);
 mot = warpMotion(w,skel,mot);

mot = fitMotion(skel,mot);
mot = addAccToMot(mot);


PCAMat=extractPCAMatFromTensor(Tensor);

for i=1:10
    optProps.recmot=addFrame2Motion(optProps.recmot,extractFrame(mot,i));
end


for f=11:mot.nframes
    
   oFrames=extractFrames(mot,1,f);
   oFrames=addAccToMot(oFrames);
   
   PCAMatWin=extractPCAMatForWindow(f,f+winlength,PCAMat);
   
   fprintf('\n\n\n\n Frame: %i \n\n\n\n',f);
   
   optProps.actFrame=f;
   
   [rFrame,optProps]=findCoefficientsFramePCA_Acce(skel,oFrames,PCAMatWin,optProps);
   
end

res=optProps.recmot;