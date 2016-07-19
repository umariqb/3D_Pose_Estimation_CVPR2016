function res=extractFrames(mot,fs,fe)

res=emptyMotion();

res.njoints     =mot.njoints;
res.nframes     =fe-fs+1;
res.frameTime   =mot.frameTime;
res.samplingRate=mot.samplingRate;

res.jointNames=mot.jointNames;
res.boneNames =mot.boneNames;
res.nameMap   =mot.nameMap;
res.animated  =mot.animated;
res.unanimated=mot.unanimated;
res.filename  =mot.filename;
res.documentation=mot.documentation;
res.angleUnit = mot.angleUnit;

for j=1:mot.njoints
    if(~isempty(mot.jointTrajectories{j})),
        res.jointTrajectories{j}=mot.jointTrajectories{j}(:,fs:fe);
    else
        res.jointTrajectories{j}=[];
    end
    
    if(~isempty(mot.rotationQuat{j}))
        res.rotationQuat{j}=mot.rotationQuat{j}(:,fs:fe);
    else
        res.rotationQuat{j}=[];
    end
    
    if(~isempty(mot.jointAccelerations{j}))
        res.jointAccelerations{j}=mot.jointAccelerations{j}(:,fs:fe);
    end
    
        
end

res.rootTranslation=mot.rootTranslation(:,fs:fe);

res.boundingBox=computeBoundingBox(res);

%               njoints: 0
%               nframes: 0
%             frameTime: 0.0083
%          samplingRate: 120
%     jointTrajectories: []
%       rootTranslation: []
%         rotationEuler: []
%          rotationQuat: []
%            jointNames: []
%             boneNames: []
%               nameMap: []
%              animated: []
%            unanimated: []
%           boundingBox: []
%              filename: ''
%         documentation: ''
%             angleUnit: 'deg'