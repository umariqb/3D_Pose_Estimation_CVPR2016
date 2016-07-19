function res=reconstructMotionPCAbased(skel,mot,PCAmat,varargin)

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

mot = fitMotion(skel,mot);

for f=1:mot.nframes
   oFrame=extractFrame(mot,f);
   
   fprintf('\n\n\n\n Frame: %i \n\n\n\n',f);
   
   [rFrame,optProps]=findCoefficientsFramePCA(skel,oFrame,PCAmat,optProps);
   
   res=addFrame2Motion(res,rFrame);
end