function [res] = compareMotionsCrossProduct(skel,mot1,mot2,varargin)

switch nargin
    case 3
        regardedJoints=1:mot1.njoints;
    case 4
        regardedJoints=varargin{1};
    otherwise
        error('Wrong number of argins!');
end
        
mot1                    = convert2euler(skel,mot1);
mot2                    = convert2euler(skel,mot2);
mot1.jointTrajectories  = forwardKinematicsQuat(skel,mot1);
mot2.jointTrajectories  = forwardKinematicsQuat(skel,mot2);
mot1                    = addBonesToMot(mot1);
mot2                    = addBonesToMot(mot2);

res.C1                  = cell(mot1.njoints,6);
res.C1Matrix            = [];
res.C2                  = cell(mot1.njoints,6);
res.C2Matrix            = [];
res.D                   = cell(mot1.njoints,6);
res.DMatrix             = [];
res.eulerMatrix         = [];
res.angleMatrix         = [];
res.mot1CrossProducts   = cell(mot1.njoints,6);
res.mot2CrossProducts   = cell(mot1.njoints,6);


for joint=regardedJoints
    % Euler error
    res.eulerMatrix=[res.eulerMatrix; abs(mot1.rotationEuler{joint}-mot2.rotationEuler{joint})];
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
            res.mot1Vectors{joint,j}=-vectors1{j}; 
            res.mot2Vectors{joint,j}=-vectors2{j}; 
            res.boneJoints{joint,j}=fliplr(endJoints{j});
        else
            res.mot1Vectors{joint,j}=vectors1{j}; 
            res.mot2Vectors{joint,j}=vectors2{j}; 
            res.boneJoints{joint,j}=endJoints{j};
        end
        res.boneLength{joint,j}=boneLengths{j};
        res.mot1NormVectors{joint,j}=normVectors1{j};
        res.mot2NormVectors{joint,j}=normVectors2{j};
    end
    epsilon=0.0000001;
    counter=0;
    for j=1:length(endJoints)-1
        for k=j+1:length(endJoints)
            counter=counter+1;
            res.mot1CrossProducts{joint,counter}=cross(res.mot1Vectors{joint,j},res.mot1Vectors{joint,k});
            res.mot2CrossProducts{joint,counter}=cross(res.mot2Vectors{joint,j},res.mot2Vectors{joint,k});
            res.C1{joint,counter}=normOfColumns(res.mot1CrossProducts{joint,counter}-res.mot2CrossProducts{joint,counter});
            res.C1Matrix=[res.C1Matrix;res.C1{joint,counter}];
                c1punkt=res.mot1CrossProducts{joint,counter}(:,2:end)-res.mot1CrossProducts{joint,counter}(:,1:end-1);
                c2punkt=res.mot2CrossProducts{joint,counter}(:,2:end)-res.mot2CrossProducts{joint,counter}(:,1:end-1);
                delta=(res.boneLength{joint,j}*res.boneLength{joint,k})./(normOfColumns(c1punkt)+normOfColumns(c2punkt)+epsilon);
            res.C2{joint,counter}=[delta.*normOfColumns(c1punkt-c2punkt) 0];
            res.C2Matrix=[res.C2Matrix;res.C2{joint,counter}];
            res.D{joint,counter}=(res.C1{joint,counter}+res.C2{joint,counter});
            res.DMatrix=[res.DMatrix;res.D{joint,counter}];
            
            res.mot1Angles{joint,counter}=real(acosd(dot(res.mot1NormVectors{joint,j},res.mot1NormVectors{joint,k})));
            res.mot2Angles{joint,counter}=real(acosd(dot(res.mot2NormVectors{joint,j},res.mot2NormVectors{joint,k})));
            res.angleMatrix=[res.angleMatrix; abs(res.mot1Angles{joint,counter}-res.mot2Angles{joint,counter})];
        end
    end
end
res.arnoDistance=sqrt(mean(res.DMatrix(:).^2));
res.eulerDistance=mean(res.eulerMatrix(:));
res.angleDistance=mean(res.angleMatrix(:));

% mot1.jointTrajectories=forwardKinematicsQuat(skel,mot1);
% mot2.jointTrajectories=forwardKinematicsQuat(skel,mot2);
% mot1=addCrossToMot(mot1);
% mot2=addCrossToMot(mot2);
% epsilon=0.0000001;
% 
% for i=1:mot1.njoints
%         c1=mot1.crossProducts{i,1};
%         c2=mot2.crossProducts{i,1};
%     res.C1(i,:)=normOfColumns(c1-c2);
%         c1punkt=mot1.crossProducts{i,1}(:,2:end)-mot1.crossProducts{i,1}(:,1:end-1);
%         c2punkt=mot2.crossProducts{i,1}(:,2:end)-mot2.crossProducts{i,1}(:,1:end-1);
%         va=mot1.crossProducts{i,2}(:,1);
%         vb=mot1.crossProducts{i,3}(:,1);
%         delta=(normOfColumns(va)*normOfColumns(vb))./(normOfColumns(c1punkt)+normOfColumns(c2punkt)+epsilon);
%     res.C2(i,:)=[delta.*normOfColumns(c1punkt-c2punkt) 0];
%     res.D(i,:)=(res.C1(i,:)+res.C2(i,:));
% end 
% 
% res.dist=sqrt(mean(res.D(:).^2));
