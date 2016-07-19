function res=reconstructMotionPCAbased_Acce(skel,mot,PCAmat,varargin)

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

jointList=varargin{1};

optProps=newOptProbs(jointList);
optProps.recmot=res;

mot = fitMotion(skel,mot);

for i=1:20
    optProps.recmot=addFrame2Motion(optProps.recmot,extractFrame(mot,i));
end


for f=21:mot.nframes
    
   oFrames=extractFrames(mot,1,f);
   oFrames=addAccToMot(oFrames);
   
   fprintf('\n\n\n\n Frame: %i \n\n\n\n',f);
   
   [rFrame,optProps]=findCoefficientsFramePCA_Acce(skel,oFrames,PCAmat,optProps);
   
end

res=optProps.recmot;