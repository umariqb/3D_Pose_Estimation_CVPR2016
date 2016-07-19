function mot =readamcsOf1Body(db,actor,user,pw)

%example:
%         mot =readamcsOf1Body('mocapdbbalmhorn','hdm_bk','mustermann','drowssap')
%

%create skel structure of choosen actor
skel =readasfDB(db,actor,user,pw);

skel = addDOFIDsToSkel(skel);

% create an empty motion
mot = emptyMotion;

% get data from skel Structure
mot.njoints = skel.njoints;
mot.jointNames = skel.jointNames;
mot.boneNames = skel.boneNames;
mot.nameMap = skel.nameMap;
mot.animated = skel.animated;
mot.unanimated = skel.unanimated;
mot.documentation = 'all frames of one choosen actor file retrieved from MoCapDB';


mot.rotationEuler=cell(skel.njoints,1);

% get connection to DB
mysql('open','131.220.242.35:3306',user, pw);
% connect to choosen DB
mysql('use',db);


% get Id from human 
humanID = ['Select id from human where skeletonname =','"',actor,'"'];
[human_id] = mysql (humanID);

% get table_names
getMotions = ['Select table_name from table_types'];
[motion_types] =  mysql (getMotions);


counter = 1;
% for all motions
for numMot=1:size(motion_types,1)
   
% get root data from DB
rootdata = ['select root1, root2, root3, root4, root5, root6 from ',motion_types{numMot,1},' where human_id ="',num2str(human_id(1,1)),'"'];
[root1, root2, root3, root4, root5, root6] =mysql (rootdata);

 if isempty([root1, root2, root3, root4, root5, root6]);
     % jump to next motion
 else

mot.rootTranslation      =[ mot.rootTranslation [root1'; root2'; root3']];
if numMot>1
    mot.rotationEuler{1,1}   =[ mot.rotationEuler{1,1}   [root4'; root5'; root6']];
else
    mot.rotationEuler{1,1}   =[root4'; root5'; root6'];
end

counter = counter+size(root1,1);
 end

end
  
% write numer of frames to mot.nframes


% get bonenames from DB
columns = ['show columns from ',motion_types{numMot,1}];
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
             counter = 1;
                % for all motions
                for numMot=1:size(motion_types,1)
                 data = ['select ', bonename,'1 from ',motion_types{numMot,1},' where human_id=','"',num2str(human_id(1,1)),'";'];
                 [bonedata1] = mysql (data); 

                  if isempty([bonedata1])
                  % jump to next motion
                  else
                      if ~isempty(mot.rotationEuler{bn,1})
                         mot.rotationEuler{bn,1}=[mot.rotationEuler{bn,1} bonedata1'];
                      else 
                         mot.rotationEuler{bn,1}=bonedata1';
                      end


                counter = counter+size(bonedata1,1);
                  end
                end    
            end   
            
          % if DOF is 2
          if k ==2
            counter = 1;
             % for all motions
            for numMot=1:size(motion_types,1)
             data = ['select ', bonename,'1,',bonename,'2 from ',motion_types{numMot,1},' where human_id=','"',num2str(human_id(1,1)),'";'];
             [bonedata1, bonedata2] = mysql (data); 
             
              if isempty([bonedata1, bonedata2])
               %jump to next motion
              else

                if ~isempty(mot.rotationEuler{bn,1})
                    mot.rotationEuler{bn,1}=[mot.rotationEuler{bn,1} [bonedata1';bonedata2']];
                else 
                    mot.rotationEuler{bn,1}=[bonedata1';bonedata2'];
                end
                
                counter = counter+size(bonedata1,1);
               end
            end   
          end
       
           % if DOF is 3
          if k ==3
             counter = 1; 
            % for all motions
            for numMot=1:size(motion_types,1)
             data = ['select ', bonename,'1,',bonename,'2,',bonename,'3 from ',motion_types{numMot,1},' where human_id=','"',num2str(human_id(1,1)),'";'];
             [bonedata1, bonedata2, bonedata3] = mysql (data); 
             
              if isempty([bonedata1,bonedata2,bonedata3])
                 % jump to next motion
              else

                if ~isempty(mot.rotationEuler{bn,1})
                 mot.rotationEuler{bn,1}=[mot.rotationEuler{bn,1} [bonedata1';bonedata2';bonedata3']];
                else 
                    mot.rotationEuler{bn,1}=[bonedata1';bonedata2';bonedata3'];
                end
                counter = counter+size(bonedata1,1);
              end
           end   
          end
      end
    end
end



% close connection
mysql ('close');

% get number of frames
mot.nframes = size(mot.rotationEuler{1,1},2);
% compute quaternions
mot = C_convert2quat(skel,mot);
% compute Trajectories
mot.jointTrajectories = C_forwardKinematicsQuat(skel,mot);
% compute boundingbox
mot.boundingBox= computeBoundingBox(mot);


