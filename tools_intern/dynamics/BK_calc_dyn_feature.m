function feature = BK_calc_dyn_feature(mot,colName,methodName,tresh,lower,upper)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculates a features based on dynamic motion parameters
% that are stored in a given CSV-file.
% 
% Possible calls:
% feature=BK_calc_dyn_feature(mot,'root_COMAcceX','doubleTreshold');
% feature=BK_calc_dyn_feature(mot,'root_COMAcceY','singleTreshold');
% feature=BK_calc_dyn_feature(mot,'root_COMAcceY','singleTreshold',100);
% feature=BK_calc_dyn_feature(mot,'root_COMAcceY','doubleTreshold',0,-1,1);
% feature=BK_calc_dyn_feature(mot,'root_COMAcceY','singleTresholdAdaptive',30);
%
% author: Björn Krüger (kruegerb@cs.uni-bonn.de)
% 
% todo: Write csv-File as binary and check if it exists
%       Implement different conversions to binary feature


%%%
% From colName we can derive which Feature is used:
% We need this to find the corresponding feature mat-file.
% [node]_E_kin    -> .kinEnergy.mat
% [node]_ForceAbs -> .force.mat
% [node]_torque   -> .torque.mat
% else we can hope that the feature data are in a hopefully
% existing .csv-file.

if ~isempty(findstr(colName, '_E_kin'))
    dataFileExt='.kinEnergy.mat';
else
    if ~isempty(findstr(colName, '_ForceAbs'))
        dataFileExt='.force.mat';
    else
        if ~isempty(findstr(colName, '_TorqueAbs'))
            dataFileExt='.torque.mat';
        else
            if ~isempty(findstr(colName,'_COMAcce'))
                dataFileExt='.COMAcce.mat';
            else
                dataFileExt=[];
                featuredata=BK_get_column_from_csv(mot,colName);
            end
        end
    end
end

if ~isempty(dataFileExt)
    featuredata=BK_get_column_from_mat(mot,colName,dataFileExt);
end

dims=size(featuredata);

%  out=strcat('Reading Column:', colName );
%  fprintf(out);

% Check number of arguments, set default values if nothing is defined.
if nargin < 4
    tresh= 0;
    lower=-1;
    upper= 1;
elseif nargin < 5
    lower=-1;
    upper= 1;
elseif nargin < 6
    upper=1;
end

% Select method
if(strcmp(methodName,'singleTreshold'))
    % Calculate logical feature
    for i=1:dims(1)-1
        if(featuredata(i)<tresh)
            feature(i)=1;
        else
            feature(i)=0;
        end
    end
end

if(strcmp(methodName,'singleTresholdAdaptive'))
    % Search Maximum:
    maxi=max(featuredata);
    value=maxi/100*tresh;
    % Calculate logical feature
    for i=1:dims(1)-1
        if(featuredata(i)<value)
            feature(i)=1;
        else
            feature(i)=0;
        end
    end
end

if(strcmp(methodName,'doubleTreshold'))
    if(featuredata(1)<0)
        feature(1)=0;
    else
        feature(1)=1;
    end
        
    for i=2:dims(1)-1
        if(feature(i-1)==0)
            if(featuredata(i)<upper)
                feature(i)=1;
            else
                feature(i)=0;
            end
        else
            if(featuredata(i)>lower)
                feature(i)=1;
            else
                feature(i)=0;
            end
        end
    end 
end

% feature is calculated, convert to logical:
feature=logical(feature);