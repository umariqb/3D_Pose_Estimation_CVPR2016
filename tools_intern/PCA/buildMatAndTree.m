function [res]=buildMatAndTree(skel,joints)

PCADataRep      = 'quat';
<<<<<<< .mine
treeDataRep     = 'acc';
=======
treeDataRep     = 'quat';
>>>>>>> .r723

global VARS_GLOBAL;
AMCPathName     = fullfile(VARS_GLOBAL.dir_root,VARS_GLOBAL.DB);
nrOfMotions     = 0;
FilterIndex     = 1;

while (FilterIndex~=0 || nrOfMotions==0)
    fprintf('Choose amc-files!\n');
    [AMCfile,AMCPathName,FilterIndex] = uigetfile(fullfile(AMCPathName,'*.amc'),'MultiSelect','on');
    if iscell(AMCfile)
        for j=1:length(AMCfile)
            fprintf('%s\n',AMCfile{j});
            nrOfMotions                 = nrOfMotions+1;
            AMCFullFile{nrOfMotions,1}  = fullfile(AMCPathName, AMCfile{j});
            ASFFullFile{nrOfMotions,1}  = fullfile(AMCPathName, [AMCfile{j}(1:6) '.asf']);
        end
    else 
        if FilterIndex~=0
            fprintf('%s\n',AMCfile);
            nrOfMotions                 = nrOfMotions+1;
            AMCFullFile{nrOfMotions,1}  = fullfile(AMCPathName, AMCfile);
            ASFFullFile{nrOfMotions,1}  = fullfile(AMCPathName, [AMCfile(1:6) '.asf']);
        elseif nrOfMotions>0
            fprintf('\nNumber of motions: %i\n',nrOfMotions);
        end
    end
end

frameRate       = input('\nSpecify frame rate: ');
res.PCAData     = [];
res.PCADataRep  = PCADataRep;
treeData        = [];
for i=1:nrOfMotions
    
    if exist([AMCFullFile{i,1} '.MAT'],'file')
        fprintf('\nReading motion %i / %i',i,nrOfMotions);
        S = load([AMCFullFile{i,1} '.MAT']);
        mot=S.mot;
    else
        fprintf('\nReading motion %i / %i\n',i,nrOfMotions);
        [skelX,mot]  = readMocap(ASFFullFile{i,1},AMCFullFile{i,1});
    end
    mot         = changeFrameRate(skel,mot,frameRate); 
    mot         = removeTranslation(skel,mot);
    mot         = removeOrientation(skel,mot);
    switch lower(res.PCADataRep)
%         case 'expmap'
%             res.res.PCAData=[res.res.PCAData cell2mat(mot.rotationQuat)];
        case 'quat'
            mot.rotationQuat(cellfun(@isempty,mot.rotationQuat))=...
                {[ones(1,mot.nframes);zeros(3,mot.nframes)]};
            res.PCAData=[res.PCAData cell2mat(mot.rotationQuat)];
%         case 'euler'
%             res.PCAData=[res.PCAData cell2mat(mot.rotationEuler)];
        case 'pos'
            res.PCAData=[res.PCAData cell2mat(mot.jointTrajectories)];
        case 'vel'
            if ~isfield(mot,'jointVelocities'), mot=addVelToMot(mot); end;
            res.PCAData=[res.PCAData cell2mat(mot.jointVelocities)];
        case 'acc'
            if ~isfield(mot,'jointAccelerations'), mot=addAccToMot(mot); end;
            res.PCAData=[res.PCAData cell2mat(mot.jointAccelerations)];
    end
    switch lower(treeDataRep)
        case 'quat'
            treeData=[treeData cell2mat(mot.rotationQuat(joints))];
        case 'euler'
            treeData=[treeData cell2mat(mot.rotationEuler(joints))];
        case 'pos'
            treeData=[treeData cell2mat(mot.jointTrajectories(joints))];
        case 'vel'
            if ~isfield(mot,'jointVelocities'), mot=addVelToMot(mot); end;
            treeData=[treeData cell2mat(mot.jointVelocities(joints))];
        case 'acc'
            if ~isfield(mot,'jointAccelerations'), mot=addAccToMot(mot); end;
            treeData=[treeData cell2mat(mot.jointAccelerations(joints))];
    end
            
end

fprintf('\nBuilding %id-tree with %i entries... ',size(treeData,1),size(treeData,2));
tic
res.tree        = kdtree(treeData');
tix=toc;
fprintf('finished in %.4f seconds.\n',tix);
res.treeDim     = size(treeData');
res.treeDataRep = treeDataRep;
res.jointList   = joints;
