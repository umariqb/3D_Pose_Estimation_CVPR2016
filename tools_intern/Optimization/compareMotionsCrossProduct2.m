function d = compareMotionsCrossProduct2(mot1,mot2,varargin)

switch nargin
    case 2
        regardedJoints=1:mot1.njoints;
    case 3
        regardedJoints=varargin{1};
    otherwise
        error('Wrong number of argins!');
end
        
mot1                    = addBonesToMot(mot1);
mot2                    = addBonesToMot(mot2);

C1                  = cell(mot1.njoints,6);
C1Matrix            = [];
C2                  = cell(mot1.njoints,6);
C2Matrix            = [];
D                   = cell(mot1.njoints,6);
DMatrix             = [];
eulerMatrix         = [];
angleMatrix         = [];
mot1CrossProducts   = cell(mot1.njoints,6);
mot2CrossProducts   = cell(mot1.njoints,6);


for joint=regardedJoints

    % search for related bones
    tmp         = cellfun(@(x)ismember(joint,x),mot1.bones.joints);
    endJoints   = mot1.bones.joints(tmp);
    boneLengths = mot1.bones.length(tmp);
    vectors1    = mot1.bones.vectors(tmp);
    vectors2    = mot2.bones.vectors(tmp);
    normVectors1    = mot1.bones.normalizedVectors(tmp);
    normVectors2    = mot2.bones.normalizedVectors(tmp);
    
    % flip bone vectors if necessary
    for j=1:length(endJoints)
        if (endJoints{j}(2))==joint 
            mot1Vectors{joint,j}=-vectors1{j}; 
            mot2Vectors{joint,j}=-vectors2{j}; 
            boneJoints{joint,j}=fliplr(endJoints{j});
        else
            mot1Vectors{joint,j}=vectors1{j}; 
            mot2Vectors{joint,j}=vectors2{j}; 
            boneJoints{joint,j}=endJoints{j};
        end
        boneLength{joint,j}=boneLengths{j};
        mot1NormVectors{joint,j}=normVectors1{j};
        mot2NormVectors{joint,j}=normVectors2{j};
    end
    
    epsilon=0.0000001;
    counter=0;
    for j=1:length(endJoints)-1
        for k=j+1:length(endJoints)
            
            counter=counter+1;
            
            mot1CrossProducts{joint,counter}=cross(mot1Vectors{joint,j},mot1Vectors{joint,k});
            mot2CrossProducts{joint,counter}=cross(mot2Vectors{joint,j},mot2Vectors{joint,k});
            C1{joint,counter}=normOfColumns(mot1CrossProducts{joint,counter}-mot2CrossProducts{joint,counter});
            C1Matrix=[C1Matrix;C1{joint,counter}];
                c1punkt=mot1CrossProducts{joint,counter}(:,2:end)-mot1CrossProducts{joint,counter}(:,1:end-1);
                c2punkt=mot2CrossProducts{joint,counter}(:,2:end)-mot2CrossProducts{joint,counter}(:,1:end-1);
                delta=(boneLength{joint,j}*boneLength{joint,k})./(normOfColumns(c1punkt)+normOfColumns(c2punkt)+epsilon);
            C2{joint,counter}=[delta.*normOfColumns(c1punkt-c2punkt) 0];
            C2Matrix=[C2Matrix;C2{joint,counter}];
            D{joint,counter}=(C1{joint,counter}+C2{joint,counter});
            DMatrix=[DMatrix;D{joint,counter}];
            
            mot1Angles{joint,counter}=real(acosd(dot(mot1NormVectors{joint,j},mot1NormVectors{joint,k})));
            mot2Angles{joint,counter}=real(acosd(dot(mot2NormVectors{joint,j},mot2NormVectors{joint,k})));

        end
    end
end
d=sqrt(mean(DMatrix(:).^2));


% mot1.jointTrajectories=forwardKinematicsQuat(skel,mot1);
% mot2.jointTrajectories=forwardKinematicsQuat(skel,mot2);
% mot1=addCrossToMot(mot1);
% mot2=addCrossToMot(mot2);
% epsilon=0.0000001;
% 
% for i=1:mot1.njoints
%         c1=mot1.crossProducts{i,1};
%         c2=mot2.crossProducts{i,1};
%     C1(i,:)=normOfColumns(c1-c2);
%         c1punkt=mot1.crossProducts{i,1}(:,2:end)-mot1.crossProducts{i,1}(:,1:end-1);
%         c2punkt=mot2.crossProducts{i,1}(:,2:end)-mot2.crossProducts{i,1}(:,1:end-1);
%         va=mot1.crossProducts{i,2}(:,1);
%         vb=mot1.crossProducts{i,3}(:,1);
%         delta=(normOfColumns(va)*normOfColumns(vb))./(normOfColumns(c1punkt)+normOfColumns(c2punkt)+epsilon);
%     C2(i,:)=[delta.*normOfColumns(c1punkt-c2punkt) 0];
%     D(i,:)=(C1(i,:)+C2(i,:));
% end 
% 
% dist=sqrt(mean(D(:).^2));
