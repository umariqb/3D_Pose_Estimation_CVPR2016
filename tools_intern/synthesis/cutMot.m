function [res]=cutMot(skel,mot,startF,endF)

res=mot;

res.nframes=endF-startF+1;

%% Cut rotational part
for i=1:res.njoints
    if(~isempty(res.rotationQuat{i}))
    	res.rotationQuat{i}=mot.rotationQuat{i}(:,startF:endF);
    end
end

%% root Translations
res.rootTranslation=mot.rootTranslation(:,startF:endF);
%res.orgFrames=mot.orgFrames(startF:endF);

%% Final clean up of other params
res.jointTrajectories = forwardKinematicsQuat(skel,res);
res.boundingBox=computeBoundingBox(res);