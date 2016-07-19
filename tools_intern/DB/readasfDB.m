function skel =readasfDB(db,name,user,pw)

%example:
%         skel =readamcDB('mocapdbbalmhorn',HDM_bk','mustermann','drowssap')
%


% cd C:\matlab_work\tools\parser;
skel = emptySkeleton;
skel.fileType = 'ASF';

%open connection
mysql('open','131.220.242.35:3306',user, pw);
% choose DB
mysql('use',db);

% get header Data from DB
header = ['select name,firstname,lastname,version, filename,mass,length,angle from human where skeletonName=','"',name,'"'];
%mysql ('select * from human where skeletonName = 'name''');
[name1,firstname,lastname,version,filename,mass,length,angle] =mysql (header);
skel.name= name1{1,1};
skel.version = version{1,1};
skel.filename = filename{1,1};
skel.lengthUnit = length;
skel.angleUnit = angle{1,1};
skel.massUnit = mass;
skel.documentation = '.asf file retrieved from MoCapDB, originally retrieved from VICON';

% get data from db
bonedatafromDB = ['Select id1, name1,direction1,direction2,direction3,length1, axis1,axis2,axis3,axis4,dof1, dof2,dof3 from bonedata where skeletonname =','"',name,'"'];
rootdatafromDB = ['Select axis1, axis2, axis3, order1, order2, order3, order4, order5, order6 from root where human_id = (Select id from human where skeletonName =','"',name,'")'];
[id1, bonename,direction1,direction2,direction3, length1,baxis1,baxis2,baxis3, axis4, dof1, dof2, dof3] = mysql (bonedatafromDB);
[axis1, axis2, axis3, order1, order2, order3, order4, order5, order6] = mysql (rootdatafromDB);
skel.boneNames{1,1} = 'root';
skel.nodes(1,1).boneName = 'root';
skel.nodes(1,1).ID = 1;
skel.nodes(1,1).parentID = 0;
skel.nodes(1,1).jointName ='root';
skel.jointNames{1,1}='root';
skel.nodes(1,1).length = 0;
skel.nodes(1,1).offset(1,1) = 0;
skel.nodes(1,1).offset(2,1) = 0;
skel.nodes(1,1).offset(3,1) = 0;
skel.nodes(1,1).direction(1,1) = 0;
skel.nodes(1,1).direction(2,1) = 0;
skel.nodes(1,1).direction(3,1) = 0;
skel.nodes(1,1).axis(1,1) = 0;
skel.nodes(1,1).axis(2,1) = 0;
skel.nodes(1,1).axis(3,1) = 0;


for i = 1:size(bonename,1);
    % write bonenames into boneNames
    skel.boneNames(i+1,1) = bonename(i,1);
    %write bonenames into nodes.bonenames
    skel.nodes(i+1,1).boneName = bonename{i,1};
    % write ID
    skel.nodes(i+1,1).ID = (id1(i,1)+1);
    %write rotationOrder
    skel.nodes(i+1,1).rotationOrder = axis4{i,1};
    % write axis
    skel.nodes(i+1,1).axis(1,1)=baxis1(i,1);
    skel.nodes(i+1,1).axis(2,1)=baxis2(i,1);
    skel.nodes(i+1,1).axis(3,1)=baxis3(i,1);
    %write length
    skel.nodes(i+1,1).length = length1(i,1) /skel.lengthUnit(1,1);    
end

bonesize = size(skel.boneNames);
skel.njoints = bonesize(1,1);
% write root order
skel.nodes(1,1).DOF(1,1) = order1;
skel.nodes(1,1).DOF(2,1) = order2;
skel.nodes(1,1).DOF(3,1) = order3;
skel.nodes(1,1).DOF(4,1) = order4;
skel.nodes(1,1).DOF(5,1) = order5;
skel.nodes(1,1).DOF(6,1) = order6;

% write  root order to skel
order = [axis1{1} axis2{1} axis3{1}];
skel.nodes(1,1).rotationOrder = order;

% write to nodedata
for h=1:30;
if isnan(dof1{h,1})==0;
skel.nodes(h+1,1).DOF(1,1) = dof1(h,1);
end;
if isnan(dof2{h,1})==0;
skel.nodes(h+1,1).DOF(2,1) = dof2(h,1);
end;
if isnan(dof3{h,1})==0;
skel.nodes(h+1,1).DOF(3,1) = dof3(h,1);
end;
skel.nodes(h+1,1).direction(1,1)= direction1(h,1);
skel.nodes(h+1,1).offset(1,1)= direction1(h,1) * skel.nodes(h+1,1).length;
skel.nodes(h+1,1).direction(2,1)= direction2(h,1);
skel.nodes(h+1,1).offset(2,1)= direction2(h,1) * skel.nodes(h+1,1).length;
skel.nodes(h+1,1).direction(3,1)= direction3(h,1);
skel.nodes(h+1,1).offset(3,1)= direction3(h,1) * skel.nodes(h+1,1).length;
end;

% find sons and write to skel
query = ['SELECT father,son FROM hierarchy WHERE species_id=(SELECT species_id FROM human WHERE skeletonName=','"',name,'")'];
[father,son] = mysql (query);
sonsid =[]; 
 
 for i= 1:size(father,1);
     query2 = ['SELECT son FROM hierarchy WHERE father =','"', father{i,1},'"',' AND species_id=(SELECT species_id FROM human WHERE skeletonName=','"',name,'")'];
     sons = mysql (query2);
     oldFather = father{i,1};    
     for j=1:size(sons,1);
          query3 = ['SELECT id1 FROM bonedata WHERE name1 =','"', sons{j,1},'"',' AND skeletonName=','"',name,'"'];
         a = mysql(query3);
         sonsid(end + 1)= a+1;
     end;    
     for b=1:size(skel.nodes);
         cf2 = strcmp(skel.nodes(b,1).boneName,oldFather);
         if cf2 == 1;
             skel.nodes(b,1).children = sonsid(:);
         end;
     end;                    
          sonsid =[];
          sons = '';
 end;
  
 % get the parentID from DB an write to skel
 for m=2:size(skel.boneNames,1);   
     query4 = ['SELECT father FROM hierarchy WHERE son =','"',skel.boneNames{m,1},'"'];
     parent = mysql(query4);
     
     if strcmp(parent,'root')==1;
     parentid = 1;
     skel.nodes(m,1).parentID = parentid;
    jointName=['root','_@_',skel.boneNames{m,1}];
     else
     query5 = ['SELECT distinct id1 FROM bonedata where name1 =','"',parent{1,1},'"'];
     parentid = mysql(query5);
     skel.nodes(m,1).parentID = parentid+1;
     jointName = [parent{1,1},'_@_',skel.boneNames{m,1}];
     end
      skel.nodes(m,1).jointName=jointName;
      skel.jointNames{m,1}=jointName;
 end
 
 % get limits from DB
 unani = 1;
 ani = 1;
 k = size(skel.nodes);
 l = k(1,1);
 for i=1:l;
    query5 =['Select limitsLow1, limitsHigh1, limitsLow2, limitsHigh2, limitsLow3, limitsHigh3 from bonedata where skeletonname =','"',name,'" AND name1=','"',skel.boneNames{i,1},'"'];
     [limitsLow1, limitsHigh1, limitsLow2, limitsHigh2, limitsLow3, limitsHigh3] = mysql(query5);
    % if limit is not an number do nothing
     if isnan(limitsLow1)==0;
         skel.nodes(i,1).limits(1,1) = limitsLow1;
     end
     % if limit is not an number do nothing
      if isnan(limitsHigh1)==0;
         skel.nodes(i,1).limits(1,2) = limitsHigh1;
      end
       % if limit is not an number do nothing
      if isnan(limitsLow2)==0;
         skel.nodes(i,1).limits(2,1) = limitsLow2;
      end
      % if limit is not an number do nothing
     if isnan(limitsHigh2)==0;
         skel.nodes(i,1).limits(2,2) = limitsHigh2;
     end
      % if limit is not an number do nothing 
     if isnan(limitsLow3)==0;
         skel.nodes(i,1).limits(3,1) = limitsLow3;
     end
     % if limit is not an number do nothing
     if isnan(limitsHigh3)==0;
         skel.nodes(i,1).limits(3,2) = limitsHigh3;
     end
        
     % ist node animated or not
     if isequal(skel.nodes(i,1).DOF,[] );
      skel.unanimated(unani,1) = i;
      unani = unani +1; 
     else 
      skel.animated(ani,1) = i;
      ani = ani+1;
     end
     
 end
 %skel = constructPaths(skel, 1, 1);
 skel.nameMap = constructNameMap(skel);

 % close connection    
mysql ('close');


