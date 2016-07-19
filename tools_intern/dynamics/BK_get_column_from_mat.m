function featuredata = BK_get_column_from_mat(mot,colName,fileExt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function loads additional data for a motion, that are stored in a
% mat file, that corresponds to a motion and a feature.
% 
% Possible call:
% featuredata=BK_getcolumn_from_mat(mot,colName,dataFileExt);
%
% author: Björn Krüger (kruegerb@cs.uni-bonn.de)

matFile = mot.csvFile;

matFile = strrep(matFile, '.csv', fileExt);

data=load(matFile);

Labels=data.Labels;
Data  =data.Data;

% % % % if(isempty(mot.csvLabels)||isempty(mot.csvData))
% % % %     % not all csv-Data are appended to the mot object 
% % % %     % -> Load from file and append
% % % %     [csvLabels,csvData]=BK_load_csv(mot.csvFile);
% % % %     mot.csvLabels=csvLabels;
% % % %     mot.csvData  =csvData;
% % % % else
% % % %     % Get Data from mot object
% % % %     csvLabels=mot.csvLabels;
% % % %     csvData  =mot.csvData;
% % % % end
% % % % 
% Search asked column and return featuredata
if(strcmp(colName,'root_COMAcce_x'))
    colName='root_2ndDerivative_x';
end
if(strcmp(colName,'root_COMAcce_y'))
    colName='root_2ndDerivative_y';
end
if(strcmp(colName,'root_COMAcce_z'))
    colName='root_2ndDerivative_z';
end

column=strmatch(colName,Labels,'exact');
featuredata=Data(:,column);