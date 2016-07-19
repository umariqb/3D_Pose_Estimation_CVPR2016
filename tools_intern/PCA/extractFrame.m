function res=extractFrame(mot,f)

res=emptyMotion();

res.njoints     =mot.njoints;
res.nframes     =1;
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
        res.jointTrajectories{j,1}=mot.jointTrajectories{j}(:,f);
    else
        res.jointTrajectories{j,1}=[];
    end
    
    if(~isempty(mot.rotationQuat{j}))
        res.rotationQuat{j,1}=mot.rotationQuat{j}(:,f);
    else
        res.rotationQuat{j,1}=[];
    end
    
    if isfield(mot,'jointAccelerations')
        if(~isempty(mot.jointAccelerations{j}))
            res.jointAccelerations{j,1}=mot.jointAccelerations{j}(:,f);
        end
    end
    
        
end

res.rootTranslation=mot.rootTranslation(:,f);

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