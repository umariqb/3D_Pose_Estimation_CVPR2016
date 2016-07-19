function mot =readamcDB(db,skel,motion,capture,user,pw)

tic;
%example:
%         mot2 =readamcDB('mocapdbbalmhorn',skel,'jumpingjack1reps','1','mustermann','drowssap')
%

% add several paths
% addpath([pwd '\animate']);
% addpath([pwd '\cutTool']);
% addpath([pwd '\parser']);
% addpath([pwd '\parser\ASFAMCparser']);
% addpath([pwd '\parser\BVHparser']);
% addpath([pwd '\parser\C3Dparser']);
% addpath([pwd '\parser\C3Dparser\LCS\callbackFunctions']);
% addpath([pwd '\parser\C3Dparser\LCS']);
% addpath([pwd '\quaternions']);
% addpath([pwd '\motionDistance'])
% addpath([pwd '\MoCapDB'])

% create an empty motion
mot = emptyMotion;

% get data from skel Structure
mot.njoints = skel.njoints;
mot.jointNames = skel.jointNames;
mot.boneNames = skel.boneNames;
mot.nameMap = skel.nameMap;
mot.animated = skel.animated;
mot.unanimated = skel.unanimated;

mot.documentation = '.amc file retrieved from MoCapDB, originally retrieved from VICON';

% get connection to DB
mysql('open','131.220.242.35:3306',user, pw);
% connect to choosen DB
mysql('use',db);
t1=toc;
% get root data from DB
rootdata = ['select root1, root2, root3, root4, root5, root6 from ',motion,' where capture=','"',capture,'";'];
[root1, root2, root3, root4, root5, root6] =mysql (rootdata);

for i = 1:size(root1,1);
    mot.rootTranslation(1,i) = root1(i,1);
    mot.rootTranslation(2,i) = root2(i,1);
    mot.rootTranslation(3,i) = root3(i,1);
    mot.rotationEuler{1,1}(1,i) = root4(i,1);
    mot.rotationEuler{1,1}(2,i) = root5(i,1);
    mot.rotationEuler{1,1}(3,i) = root6(i,1);
end

% write numer of frames to mot.nframes
mot.nframes = size(root1,1);

% get bonenames from DB
columns = ['show columns from ',motion];
[field,Type,null,Key,Default,Extra] = mysql (columns);

%for every bonename
for bn = 2:size(mot.boneNames,1);
    bonename = mot.boneNames{bn,1};
    k=0;
    
    % for every bonemane get the number of entries
    for fn = 1:size(field,1)
        % get name of field
        fieldname = field(fn,1);
        % get length of bonename
        l = length(bonename);
        % check if the fieldname ist qual to the bonenname without the
        % enumeration
        if strncmp(bonename,fieldname,l)
        k=k+1;
        end
    end
    

    if strcmp(bonename, 'lhipjoint') 
    % is not animated
    % do nothing
    else
        if strcmp(bonename, 'rhipjoint')
        % is not animated
        % do nothing
        else

            % if DOF is 1
            if k ==1
             data = ['select ', bonename,'1 from ',motion,' where capture=','"',capture,'";'];
             [bonedata1] = mysql (data);   
                for g = 1:size(bonedata1,1)
                 mot.rotationEuler{bn,1}(1,g) = bonedata1(g,1);
                end
            end
    
            % if DOF is 2
            if k ==2
             data = ['select ', bonename,'1, ', bonename,'2 from ',motion,' where capture=','"',capture,'";'];
             [bonedata1, bonedata2] = mysql (data);
                for g = 1:size(bonedata1,1)
                 mot.rotationEuler{bn,1}(1,g) = bonedata1(g,1);
                 mot.rotationEuler{bn,1}(2,g) = bonedata2(g,1);
                end
            end
       
           % if DOF is 3
           if k ==3
            data = ['select ', bonename,'1, ', bonename,'2, ',bonename,'3 from ',motion,' where capture=','"',capture,'";'];
            [bonedata1, bonedata2, bonedata3] = mysql (data);
                for g = 1:size(bonedata1,1)
                 mot.rotationEuler{bn,1}(1,g) = bonedata1(g,1);
                 mot.rotationEuler{bn,1}(2,g) = bonedata2(g,1);
                 mot.rotationEuler{bn,1}(3,g) = bonedata3(g,1);
                end
         end
      end
    end
end

% get Name of amc file
skeletonname = ['Select skeletonname from human where id = (Select distinct human_id from ',motion,' where capture = ','"',capture,'")'];
[skelname] = mysql(skeletonname);

extendedCapture = capture;
% create correct capture
for i = length(capture):2
    extendedCapture = ['0',extendedCapture];
end
mot.filename = [skelname{1,1},'_',motion,'_',extendedCapture];

t2=toc;
% close connection
mysql ('close');
% compute quaternions
mot=convert2quat(skel,mot);
% compute Trajectories
mot.jointTrajectories = forwardKinematicsQuat(skel,mot);
% compute boundingbox
mot.boundingBox= computeBoundingBox(mot);
t3=toc;

fprintf('Build connection : %f\n',t1);
fprintf('Get data         : %f\n',t2-t1);
fprintf('Close connection : %f\n',t3-t2);

